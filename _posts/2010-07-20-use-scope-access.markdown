---
layout: post
title: Use scope access
author: Wen-Tien Chang
description: You can use scope access to avoid checking the permission by comparing the owner of object with current_user in controller.
tags:
- controller
---
If you check the permission by comparing the owner of object with current_user, it's verbose and ugly, you can use scope access to avoid this.

Bad Smell
---------

    class PostsController < ApplicationController
      def edit
        @post = Post.find(params[:id])
        if @post.user != current_user
          flash[:warning] = 'Access denied'
          redirect_to posts_url
        end
      end
    end

In this example, we compare the user of post with current_user, if the condition returns false, do not allow user to edit the post. But it's too verbose to do this permission check for edit, update, destroy and etc. Let's use scope access to refactor.

Refactor
--------

    class PostsController < ApplicationController
      def edit
        # raise RecordNotFound exception (404 error) if not found
        @post = current_user.posts.find(params[:id])
      end
    end

So we find the post only in current_user.posts that can promise the post is owned by current_user, if not, a 404 error will be raised.

We have no needs to compare the owner with current_user, just use scope access to make permission check simpler.

