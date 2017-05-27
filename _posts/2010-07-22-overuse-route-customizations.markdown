---
layout: post
title: Overuse route customizations
author: Wen-Tien Chang
description: According to Roy Fieldingâ€™s doctoral thesis, we should use restful routes to represent the resource and its state. Use the default 9 actions without overusing route customizations.
tags:
- rails2
- route
---
Bad Smell
---------

    map.resources :posts, :member => { :comments => :get,
                                       :create_comment => :post,
                                       :update_comment => :put,
                                       :delete_comment => :delete }

According to Roy Fieldingâ€™s doctoral thesis, we should use restful routes to represent the resource and its state. Use the default 9 actions(index, show, new, edit, create, update and destroy) without overusing route customizations. The solution to solve the overuse route customizations is to find another resources

Refactor
--------

    map.resources :posts do |post|
      post.resources :comments
    end

So we use a new resources comments to avoid customization route create_comment, update_comment and delete_comment for resources post. Remember to use the default 7 actions for routes as possible as you can.
