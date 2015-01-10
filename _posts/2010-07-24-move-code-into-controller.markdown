---
layout: post
title: Move code into controller
author: Wen-Tien Chang (ihower@gmail.com)
description: According to MVC architecture, there should not be logic codes in view, in this practice, I will introduce you to move codes into controller.
tags:
- controller
- view
likes:
- ihower (ihower@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- eric (eric@pixelwareinc.com)
- ixandidu (ixandidu@gmail.com)
- madeofcode (markdodwell@gmail.com)
- tjsingleton (tjsingleton@vantagestreet.com)
- akoc (aivars.akots@gmail.com)
- regedor (miguelregedor@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- matthewcford (matt@bitzesty.com)
- ahmad.alkheat.5 (wisamfaithful@gmail.com)
dislikes:
- 
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
