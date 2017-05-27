---
layout: post
title: Use query attribute
author: Richard Huang
description: Do you always check if ActiveRecord's attributes exist or not by nil?, blank? or present? ? Don't do that again, rails provides a cleaner way by query attribute
tags:
- model
---
Bad Smell
---------

    <% if @user.login.blank? %>
      <%= link_to 'login', new_session_path %>
    <% end %>

    <% if @user.login.present? %>
      <%= @user.login %>
    <% end %>

It's not bad, but rails provides a cleaner way, we should use query attributes to make codes simpler

Refactor
--------

    <% unless @user.login? %>
      <%= link_to 'login', new_session_path %>
    <% end %>

    <% if @user.login? %>
      <%= @user.login %>
    <% end %>

As you seen, the query attribute is almost the same as the present? method call on attribute, or the opposite of blank? method call. Each attribute of ActiveRecord's model has a query method, so you don't need to use the present? or blank? for ActiveRecord's attributes.
