---
layout: post
title: Select specific fields for performance
author: Richard Huang (flyerhzm@gmail.com)
description: In a system like forum, the title and body is displayed on show page, but only title is on index page. You should use select in query to speed up the query and save memory.
tags:
- performance
- query
likes:
- flyerhzm (flyerhzm@gmail.com)
- Priit Tamboom ()
- loushizan (loushizan@gmail.com)
- Mikhail ()
- Marcelo G. Silva (mgswolf@gmail.com)
- dchou (dchou@iscreen.com)
- juancolacelli (juancolacelli@gmail.com)
- PsiCat (ogealter@gmail.com)
dislikes:
- railsfan (railsfan@gmail.com)
- José Galisteo Ruiz ()
- mtodd (chiology@gmail.com)
---
Before
------

In the rails-bestpractices.com, rails best practices are saved as Post model. The database schema of the Post model is

    create_table "posts", :force => true do |t|
      t.string   "title"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "user_id"
      t.text     "formatted_html"
      t.text     "description"
      ...
    end

The posts index page displays 10 posts. At the beginning, I used

    class PostsController < ApplicationController
      def index
        @posts = Post.paginate(:page => params[:page])
      end
    end

to fetch posts from database. The query sql is as follows.

    SELECT `posts`.* FROM `posts`  LIMIT 0, 10

It was slow when the posts had large body.

Refactor
--------

Then I began to improve the performance. In the posts index page, the body, formatted_html and updated_at are no use, but the body and formatted_html occupy lots of memory, for example, the average size of body is 2k and formatted_html is also 2k, the posts index page display 10 posts per page, so the system wastes 40k memory each posts index request, and it also wastes time to fetch them from database. So I decided to remove theses fields from query.

In rails3 there is a method "select" to fetch specific fields, in rails2 you can also use select option in find method. Here I only give you the rails3 way.

    class Post < ActiveRecrod::Base
      INDEX_COLUMNS = column_names - ['body', 'formatted_html', 'updated_at']
    end

    class PostsController < ApplicationController
      def index
        @posts = Post.select(Post::INDEX_COLUMNS).paginate(:page => params[:page])
      end
    end

Here rails tells database fetch all the fields except body, formatted_html and updated_at, now the query sql is as follows

    SELECT id, title, created_at, user_id, description FROM `posts` LIMIT 0, 10

As you see, there are no body, formatted_html and updated_at in query sql, it is faster than before and use less memory.

**Update**: You should not select specific fields if you use memory object caching system, such as memcache.
