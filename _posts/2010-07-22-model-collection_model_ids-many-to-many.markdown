---
layout: post
title: model.collection_model_ids (many-to-many)
author: Wen-Tien Chang
description: When you want to associate a model to many association models by checkbox on view, you should take advantage of model.collection_model_ids to reduce the code in controller.
tags:
- controller
- model
- view
---
Bad Smell
---------

    class User < ActiveRecord::Base
      has_many :user_role_relationships
      has_many :roles, :through => :user_role_relationships
    end

    class UserRoleRelationship < ActiveRecord::Base
      belongs_to :user
      belongs_to :role
    end

    class Role < ActiveRecord::Base
    end

    <% form_for @user do |f| %>
      <%= f.text_field :email %>
      <% Role.all.each |role| %>
        <%= check_box_tag 'role_id[]', role.id, @user.roles.include?(role) %>
        <%= role.name %>
      <% end %>
    <% end %>

    class UsersController < ApplicationController
      def update
        @user = User.find(params[:id])
        if @user.update_attributes(params[:user])
          @user.roles.delete_all
          (params[:role_id] || []).each { |i| @user.roles << Role.find(i) }
        end
      end
    end

As you see, user and role models are many to many, and there is a form to associate one user to many roles. In the controller, we first remove all the roles of the user, then assign the roles to user according to the selection on checkbox. It's ugly to assign the roles to user by ourselves, we should use rails's facility.

Refactor
--------

    <% form_for @user do |f| %>
      <% Role.all.each |role| %>
        <%= check_box_tag 'user[role_ids][]', role.id, @user.roles.include?(role) %>
        <%= role.name %>
      <% end %>
      <%= hidden_field_tag 'user[role_ids][]', '' %>
    <% end %>

    class UsersController < ApplicationController
      def update
        @user = User.find(params[:id])
        @user.update_attributes(params[:user])
        # the same as @user.role_ids = params[:user][:role_ids]
      end
    end

What we do is changing the name of checkbox from "role_id[]" to "user[role_ids][]", so the role_ids will be automatically assigned to the user model. Please note that there is a hidden_field_tag 'user[role_ids][]', its value is empty, which promises that all the roles association to user will be destroyed if no user roles checkbox selected. Now our controller keeps simple again.
