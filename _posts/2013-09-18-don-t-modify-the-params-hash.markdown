---
layout: post
title: Don't modify the params hash
author: David Davis (ddavis1@gmail.com)
description: The params hash contains all the data that was submitted from a request. If you modify it, later code won't have access to it. Instead, copy the params hash and modify the copy.
tags:
- controller
- params
likes:
- t27duck (t27duck@gmail.com)
- PriteshRocks (prit.jain86@gmail.com)
- sandeepkrao (skr.ymca@gmail.com)
- aaronpark (apark73@gmail.com)
- budhrg (budhrg@gmail.com)
dislikes:
- 
---
## Before

Don't modify the params hash.

     def search
       params.except!(:action, :controller)
       @search = User.search(params)
       render "search"
     end

Supposing someone later would add code to the end of this action that needed params[:action] or params[:controller], they would have to refactor your code.

## Refactor

Instead copy the params hash.

    def search
       filter = params.except(:action, :controller)
       @search = User.search(filter)
       render "search"
    end

Better yet, create a separate params method like you would with strong_parameters. If you know the keys:

    def search
      @search = User.search(search_params)
      render "search"
    end

    private
    
    def search_params
      # params.except(:action, :controller)
      params.permit(:user_id, :name)
    end
