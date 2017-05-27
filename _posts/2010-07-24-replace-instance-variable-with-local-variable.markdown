---
layout: post
title: Replace instance variable with local variable
author: Wen-Tien Chang
description: In partial view, we can use the instance variable directly, but it may be confused and make it hard to reuse anywhere, because we don't know exactly which instance variable can be used, so use the local variable in partial with explicitly assignment.
tags:
- view
---
A partial is a reusable view template, it allow you to modularize the components which make up a particular page into logical, cohesive pieces. When required data is not passed into a partial, it is often difficult to reuse or change later.

By passing the required data in as locals you create self-documenting requirements for each view
partial. It also helps to see where else it is rendered and what locals are required.

Bad Smell
---------

    class PostsController < ApplicationController
      def show
        @post = Post.find(params[:id])
      end
    end

    <%= render :partial => "sidebar" %>

In this example, the partial sidebar can use the instance variable @post, but we can't know what's the instance variable @post without checking the controller codes. Let's use the local variable instead.

Refactor
--------

    <%= render :partial => "sidebar", :locals => { :post => @post } %>

or

    <%= render "sidebar", :post => @post %>

Now we can use the local variable post in partial, it is much simpler.

