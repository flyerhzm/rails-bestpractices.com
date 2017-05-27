---
layout: post
title: Add model virtual attribute
author: Wen-Tien Chang
description: Do not assign the model's attributes directly in controller. Add model virtual attribute to move the assignment to model.
tags:
- controller
- model
---
Bad Smell
---------

    <% form_for @user do |f| %>
      <%= text_field_tag :full_name %>
    <% end %>

    class UsersController < ApplicationController
      def create
        @user = User.new(params[:user])
        @user.first_name = params([:full_name]).split(' ', 2).first
        @user.last_name = params([:full_name]).split(' ', 2).last
        @user.save
      end
    end

In this example, the user form contains a full_name attribute, but we want to save the first_name and last_name in table, so we assign the first_name an last_name for @user object in controller by splitting the full_name.

But assigning attributes for model is not the job of controller, you should let model to handle this by adding virtual attribute.

Refactor
--------

    class User < ActiveRecord::Base
      def full_name
        [first_name, last_name].join(' ')
      end

      def full_name=(name)
        split = name.split(' ', 2)
        self.first_name = split.first
        self.last_name = split.last
      end
    end

    <% form_for @user do |f| %>
      <%= f.text_field :full_name %>
    <% end %>

    class UsersController < ApplicationController
      def create
        @user = User.create(params[:user])
      end
    end

Now User model adds the virtual attribute full_name=, whose function is to assign first_name and last_name. It's cool because we can use only one line to create a user, and User model will split the full_name and assign first_name and last_name by itself.
