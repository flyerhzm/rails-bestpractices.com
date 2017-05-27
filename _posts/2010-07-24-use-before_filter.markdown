---
layout: post
title: Use before_filter
author: Wen-Tien Chang
description: Don't repeat yourself in controller, use before_filter to avoid duplicated codes.
tags:
- controller
---
Bad Smell
---------

    class PostsController < ApplicationController
      def show
        @post = current_user.posts.find(params[:id])
      end

      def edit
        @post = current_user.posts.find(params[:id])
      end

      def update
        @post = current_user.posts.find(params[:id])
        @post.update_attributes(params[:post])
      end

      def destroy
        @post = current_user.posts.find(params[:id])
        @post.destroy
      end
    end

In this example, the first code in action show, edit, update and destroy are the same, we hate the duplicated code, use before_filter  to avoid.

Refactor
--------

    class PostsController < ApplicationController
      before_filter :find_post, :only => [:show, :edit, :update, :destroy]

      def update
        @post.update_attributes(params[:post])
      end

      def destroy
        @post.destroy
      end

      protected
        def find_post
          @post = current_user.posts.find(params[:id])
        end
    end

As you see, all the post finders are removed from actions, and there is only one finder in the before_filter. Keep in mind that don't repeat yourself(DRY).

**updated**: in rails 4 or newer versions, you should use before_action instead of before_filter.
