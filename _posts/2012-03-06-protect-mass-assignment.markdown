---
layout: post
title: Protect mass assignment
author: Richard Huang
description: Rails mass assignment feature is really useful, but it may be a security issue, it allows an attacker to set any models' attributes you may not expect. To avoid this, we should add attr_accessbile or attr_protected to all models.
tags:
- model
- security
---
Last weekend github is hacked because of mass assignment issue, actually it's not rails fault, it's a "junior" develop forgot to add attr_accessible or attr_protected to model, like

Problem
------

    class User < ActiveRecord::Base
    end

    class UsersController < ApplicationController
      def update
        if current_user.update_attributes(params[:user])
          # do something
        end
      end
    end

if hacker can pass params[:user][:role] = 'admin', he may get admin privilege and do anything in your system, it's horrible.

Solution
--------

Rails provides methods attr_accessible and attr_protected to solve this issue, but developers are too lazy and always forget to add them to models. If the way to solve security issue is not default,  it is not security. Just like how rails3 solve XSS issue, rails should make it default way to protect attributes. Before rails do it, we should add attr_accessible or attr_protected to all models.

    class User < ActiveRecord::Base
      attr_accessible :email, :password, :password_confirmation, :remember_me
    end

From rails 3.1, a new configuration is introduced

    config.active_record.whitelist_attributes = true

It will create an empty whitelist of attributes available for mass-assignment for all models in your app.

It's important to protect your system, don't be lazy any more.
