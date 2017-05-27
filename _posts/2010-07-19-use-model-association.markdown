---
layout: post
title: Use model association
author: Wen-Tien Chang
description: Use model association to avoid assigning reference in controller.
tags:
- controller
- model
---
Bad Smell
---------

    class PostsController < ApplicationController
      def create
        @post = Post.new(params[:post])
        @post.user_id = current_user.id
        @post.save
      end
    end

In this example, user_id is assigned to @post explicitly. It's not too big problem, but we can save this line by using model association.

Refactor
--------

    class PostsController < ApplicationController
      def create
        @post = current_user.posts.build(params[:post])
        @post.save
      end
    end

    class User < ActiveRecord::Base
      has_many :posts
    end

We define the association that user has many posts, then we can just use current_user.posts.build or current_user.posts.create to generate a post, and the current_user's id is assigned to the user_id of the post automatically by activerecord.
