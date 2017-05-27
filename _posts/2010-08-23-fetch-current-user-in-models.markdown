---
layout: post
title: Fetch current user in models
author: Richard Huang
description: I don't remember how many times I need to fetch current user in models, such as audit log. Here is a flexible way to set the current user in and fetch the current user from User model.
tags:
- model
---
I don't remember how many times I need to fetch the current user in models, for example, I want to log who creates, updates or destroys a post in the Audit model. There is no default way to fetch the current user in models, current_user object is always assigned in controllers (thanks to authentication plugins, restful_authentication, authlogic and devise), we can pass the current user object from controllers to models, but it is too ugly. I think the better way is to add the current user to User model by Thread.current hash.

    class User < ActiveRecord::Base
      def self.current
        Thread.current[:user]
      end
      def self.current=(user)
        Thread.current[:user] = user
      end
    end

As you seen, we add two class methods to User model, User.current to fetch the current user and User.current= to assign the current user. So what you need to do is to assign the current user in User model every request you need a current user. Such as

    class ApplicationController < ActionController::Base
        def set_current_user
          User.current = current_user
        end
    end

    class PostsController < ApplicationController
      before_filter :require_user # require_user will set the current_user in controllers
      before_filter :set_current_user
    end

Now you can easily fetch the current_user in models by User.current, enjoy it!
