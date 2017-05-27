---
layout: post
title: Move code into controller
author: Wen-Tien Chang
description: According to MVC architecture, there should not be logic codes in view, in this practice, I will introduce you to move codes into controller.
tags:
- controller
- view
---
Bad Smell
---------

    <% @posts = Post.find(:all) %>
    <% @posts.each do |post| %>
      <%=h post.title %>
      <%=h post.content %>
    <% end %>

According to MVC architecture, there should not be logic codes in view. The posts finder should not exist in view, please move it into controller.

Refactor
--------

    class PostsController < ApplicationController
      def index
        @posts = Post.find(:all)
      end
    end

Now we move the posts finder into controller, we can use the @posts directly in view.
