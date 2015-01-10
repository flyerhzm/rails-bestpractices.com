---
layout: post
title: Move Model Logic into the Model
author: Wen-Tien Chang (ihower@gmail.com)
description: In MVC model, controller should be simple, the business logic is model's responsibility. So we should move logic from controller into the model.
tags:
- controller
- model
likes:
- ihower (ihower@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- pake007 (pake007@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
dislikes:
- mdeering (mdeering@mdeering.com)
---
Bad Smell
---------

    class PostsController < ApplicationController
      def publish
        @post = Post.find(params[:id])
        @post.update_attribute(:is_published, true)
        @post.approved_by = current_user
        if @post.created_at > Time.now - 7.days
          @post.popular = 100
        else
          @post.popular = 0
        end
    
        redirect_to post_url(@post)
      end
    end

In this example, PostsController wants to publish a post, first it finds a post, set post's attribute is_published and approved, and assigns the popular attribute according to the value of created_at, PostsController knows too much about the logic, it is not controller's responsibility, it should be handled by model.

Refactor
--------

    class Post < ActiveRecord::Base
      def publish
        self.is_published = true
        self.approved_by = current_user
        if self.created_at > Time.now - 7.days
          self.popular = 100
        else
          self.popular = 0
        end
      end
    end
    
    class PostsController < ApplicationController
      def publish
        @post = Post.find(params[:id])
        @post.publish
    
        redirect_to post_url(@post)
      end
    end

Now we move the publish logic from controller into the model, create a publish method for Post model, then we just call the publish method in controller. It looks beautiful.
