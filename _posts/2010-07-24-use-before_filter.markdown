---
layout: post
title: Use before_filter
author: Wen-Tien Chang (ihower@gmail.com)
description: Don't repeat yourself in controller, use before_filter to avoid duplicated codes.
tags:
- controller
likes:
- ihower (ihower@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- gdurelle (gregory.durelle@gmail.com)
- andreyviana (andreydjason@gmail.com)
- danielpamich (danielpamich@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- bluejade (dnelson@centresource.com)
- nathanvda (nathan@dixis.com)
- pain666 (nick@firedev.com)
- chris.passarella (chrispassarella78@gmail.com)
dislikes:
- eric (eric@pixelwareinc.com)
- Doug Johnston ()
- beerlington (pete@lette.us)
- Carlos Brando (eduardobrando@gmail.com)
- railsjedi (railsjedi@gmail.com)
- leobessa (leobessa@gmail.com)
- leobessa (leobessa@gmail.com)
- regedor (miguelregedor@gmail.com)
- lorenzk (lorenz@kitzmann.com)
- jkhart (jk@jkhart.com)
- zzzhc (zzzhc.cn@gmail.com)
- stouset (stephen@touset.org)
- whitethunder (mattw922@gmail.com)
- tarasevich (tarasevich.a@gmail.com)
- khani3s (felipenavas@gmail.com)
- rupert654 (rupert@madden-abbott.com)
- eagleas (eagle.alex@gmail.com)
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
