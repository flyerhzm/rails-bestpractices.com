---
layout: post
title: Move code into model
author: Wen-Tien Chang (ihower@gmail.com)
description: According to MVC architecture, there should not be logic codes in view, in this practice, I will introduce you to move codes into model.
tags:
- model
- view
likes:
- ihower (ihower@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- eric (eric@pixelwareinc.com)
- iGEL (igel@igels.net)
- dylanfm (dylan.fm@gmail.com)
- madeofcode (markdodwell@gmail.com)
- akoc (aivars.akots@gmail.com)
- profile.php?id=612775632 (jin4rill@yahoo.com)
- juancolacelli (juancolacelli@gmail.com)
- matthewcford (matt@bitzesty.com)
dislikes:
- 
---
Bad Smell
---------

    <% if current_user && (current_user == @post.user ||
                           @post.editors.include?(current_user)) %>
      <%= link_to 'Edit this post', edit_post_url(@post) %>
    <% end %>

In this example, we check the edit permission in view with a complex code, but complex logic codes should not be placed in view, we should move it to model.

Refactor
--------

    <% if @post.editable_by?(current_user)) %>
      <%= link_to 'Edit this post', edit_post_url(@post) %>
    <% end %>
    
    class Post < ActiveRecord::Base
      def editable_by?(user)
        user && (user == self.user || self.editors.include?(user))
      end
    end

Now it's clear that we move the permission logic into editable_by? method in model, that makes the view code more readable and we can easily reuse the editable_by? logic in other view files.
