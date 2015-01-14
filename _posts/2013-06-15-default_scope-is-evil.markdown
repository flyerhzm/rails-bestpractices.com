---
layout: post
title: default_scope is evil
author: Richard Huang (flyerhzm@gmail.com)
description: ActiveRecord provides default_scope to set a default scope for all operations on the model, it looks convenient at first, but will lead to some unexpected behaviors, we should avoid using it. 
tags:
- model
likes:
- flyerhzm (flyerhzm@gmail.com)
- allanlewis99 (allanlewis99@gmail.com)
- matthewcford (matt@bitzesty.com)
- marocchino (marocchino@gmail.com)
- jakswa (jakswa@gmail.com)
- leolukin (leolukin@gmail.com)
- parasharrk (parasharragh@gmail.com)
- bugmenot (fhugfizn@sharklasers.com)
- PatrickSimply (yinghau76@gmail.com)
- map7 (michael@dtcorp.com.au)
- t27duck (t27duck@gmail.com)
- 风之暗殇典 (gaodu328110@163.com)
- daviddavis (ddavis1@gmail.com)
- mayinx (mayinxx@web.de)
- vsh (init13@gmail.com)
- dvl8684 (dvl8684@gmail.com)
- ice5050 (ice50505050@hotmail.com)
- budhrg (budhrg@gmail.com)
- elfadiliy (yassine@elfadili.com)
- naixspirit (neverlandxy.naix@gmail.com)
- Aaditi Jain (aaditi2290@gmail.com)
dislikes:
- Alfuken ()
---
I have used default_scope many times before, but later I regretted doing so.

Assume we defined a default_scope in Post model

    class Post
      default_scope where(published: true).order("created_at desc")
    end

default_scope added some behaviors that you may not expect.

 1\. **You can't override default scope.** e.g. by default, it lists posts order by created_at,

    > Post.limit(10)
      Post Load (3.3ms)  SELECT `posts`.* FROM `posts` WHERE `posts`.`published` = 1 ORDER BY created_at desc LIMIT 10

if you want to display posts order by updated_at rather than created_at, you may use the following line,

    > Post.order("updated_at desc").limit(10)
      Post Load (17.3ms)  SELECT `posts`.* FROM `posts` WHERE `posts`.`published` = 1 ORDER BY created_at desc, updated_at desc LIMIT 10

but as you can see, it order by both created_at and updated_at, default scope is not overriden, you have to use unscoped to disable default scope explicitly,

    > Post.unscoped.order("updated_at desc").limit(10)
      Post Load (1.9ms)  SELECT `posts`.* FROM `posts` ORDER BY updated_at desc LIMIT 10

so you have to remember the model has a default_scope, and add unscoped if you want to override the default scope, it's an accident waiting to happen.

2\. **default_scope will affect your model initialization.** e.g.

    > Post.new
    => #<Post id: nil, title: nil, created_at: nil, updated_at: nil, user_id: nil, published: true>

most developers are not aware this point, they think default_scope only affect queries, it is the wrong way default_scope does.

Don't use default_scope any more, just define it as a scope and explictly call that scope.
