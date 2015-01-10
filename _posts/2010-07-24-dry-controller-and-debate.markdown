---
layout: post
title: DRY Controller (and debate)
author: Wen-Tien Chang (ihower@gmail.com)
description: For CRUD resources, we always write the same 7 actions with duplicated codes. To avoid this, you can use inherited_resources plugin. But be careful, there is DRY controller debate!! (http://www.binarylogic.com/2009/10/06/discontinuing-resourcelogic/)  1. You lose intent and readability 2. Deviating from standards makes it harder to work with other programmers 3. Upgrading rails trouble
tags:
- controller
- plugin
likes:
- ihower (ihower@gmail.com)
- slavix (admin@slavix.com)
- fireflyman (yangxiwenhuai@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- matthewcford (matt@bitzesty.com)
dislikes:
- eric (eric@pixelwareinc.com)
- David Westerink (davidakachaos@gmail.com)
---
Before Refactor
---------

    class PostsController < Applicationcontroller
      def index
        @posts = Post.all
      end
    
      def show
        @post = Post.find(params[:id])
      end
    
      def new
        @post = Post.new
      end
    
      def create
        @post.create(params[:post])
        redirect_to post_path(@post)
      end
    
      def edit
        @post = Post.find(params[:id])
      end
    
      def update
        @post = Post.find(params[:id])
        @post.update_attributes(params[:post])
        redirect_to post_path(@post)
      end
    
      def destroy
        @post = Post.find(params[:id])
        @post.destroy
        redirect_to posts_path
      end
    end

For CRUD resources, you always write the 7 actions with duplicated codes.

After Refactor
--------------

    class PostsController < InheritedResources::Base
      # magic!! nothing here!
    end

Using [inherited_resources][1] gem, you can avoid repeating yourself, the controller files are really clean.

Updated: thanks @carlosantoniodasilva

Updated: Add debate

  [1]: http://github.com/josevalim/inherited_resources
