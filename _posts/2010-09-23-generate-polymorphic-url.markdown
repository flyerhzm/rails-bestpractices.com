---
layout: post
title: Generate polymorphic url
author: Richard Huang (flyerhzm@gmail.com)
description: If you want to generate different urls according to different objects, you should use the polymorphic_path/polymorphic_url to simplify the url generation.
tags:
- view
- helper
likes:
- grigio ()
- flyerhzm (flyerhzm@gmail.com)
- Sulymosi Gergő ()
- ripnix ()
- José Galisteo Ruiz ()
- indrekj (indrek@urgas.eu)
- samir (samirbraga@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- Locke23rus (locke23rus@gmail.com)
- dgilperez (dgilperez@gmail.com)
- chalcchuck (chalcchuck@gmail.com)
dislikes:
- 
---
Imagine that we have three models, Post, News and Comment. It's common that a post has many comments and a news has many comments, so we define them as

    class Post < ActiveRecord::Base
      has_many :comments
    end
    class News < ActiveRecord::Base
      has_many :comments
    end
    class Comment < ActiveRecord::Base
      belongs_to :commentable, :polymorphic => true
    end

And we define the routes here

    resources :posts do
      resources :comments
    end
    resources :news do
      resources :comments
    end

What if you want to generate the url for posts' comments and news' comments?

Bad Smell
---------

this is the common way to get the url for post's comments and news' comments

    # parent may be a post or a news
    if Post === parent
      post_comments_path(parent)
    elsif News === parent
      news_comments_path(parent)
    end

this can get the url for post and news

    if Post === parent
      post_path(parent)
    elsif News === parent
      news_path(parent)
    end

Refactor
--------

Rails provides a simple way to generate the polymorphic url.

So we can use the polymorphic_path to get the url for post's comments and news' comments

    polymorphic_path([parent, Comment])    # "/posts/1/comments" or "'news/1/comments"

and this can get the url for post and news

    polymorphic_path(parent)    # "http://example.com/posts/1/comments" or "http://example.com/news/1/comments"

polymorphic_path makes polymorphic url generation much easier and simpler. There is also a method named polymorphic_url which is the same as the polymorphic_path except that polymorphic_url generate the full url including the host name.

Besides these, rails also provides the new and edit action for polymorphic_path/polymorphic_url

    new_polymorphic_path(Post)    # "/posts/new"
    new_polymorphic_url(Post)    # "http://example.com/posts/new"
    edit_polymorphic_path(post)    # "/posts/1/edit"
    edit_polymorphic_url(post)    # "http://example.com/posts/1/edit"
