---
layout: post
title: Move finder to named_scope
author: Wen-Tien Chang
description: Complex finders in controller make application hard to maintain. Move them into the model as named_scope can make the controller simple and the complex find logics are all in models.
tags:
- rails2
- controller
- model
---
Bad Smell
---------

    class PostsController < ApplicationController
      def index
        @published_posts = Post.find(:all, :conditions => { :state => 'published' },
                                           :limit => 10,
                                           :order => 'created_at desc')

        @draft_posts = Post.find(:all, :conditions => { :state => 'draft' },
                                       :limit => 10,
                                       :order => 'created_at desc')
      end
    end

In this example, PostsController uses two complex finders to get the published_posts and draft_posts. There are 2 bad smells:

 1. The controller method contains complex finders is always too long, which make it difficult to read.
 2. The same complex finders may be existed in different controllers, if you change the logic, you have to change the complex finders in different place, which adds the possibilities to create bugs.

Refactor
--------


    class PostsController < ApplicationController
      def index
        @published_posts = Post.published
        @draft_posts = Post.draft
      end
    end

    class Post < ActiveRecord::Base
      named_scope :published, :conditions => { :state => 'published' },
                              :limit => 10,
                              :order => 'created_at desc'
      named_scope :draft, :conditions => { :state => 'draft' },
                          :limit => 10,
                          :order => 'created_at desc'
    end

Now, we move the complex finder from controller to model. As you seen, code in controller are really simpler and more readable. Complex finders are existed only in models, so if your logic changes, you just want to change the code in model.

**updated**: in rails 3 or newer versions, you should use scope instead of named_scope.
