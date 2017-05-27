---
layout: post
title: Love named_scope
author: Wen-Tien Chang
description: named_scope is awesome, it makes your codes much more readable, you can also combine named_scope finders to do complex finders.
tags:
- rails2
- controller
- model
---
Bad Smell
---------

    class PostsController < ApplicationController
      def search
        conditions = { :title => "%#{params[:title]}%" } if params[:title]
        conditions.merge! { :content => "%#{params[:content]}%" } if params[:content]

        case params[:order]
        when "title" : order = "title desc"
        when "created_at : order = "created_at desc"
        end

        @posts = Post.find(:all, :conditions => conditions, :order => order,
                                 :limit => params[:limit])
      end
    end

This is a complex finder in controller, it contains fuzzy query, order and limit, it is confused and the complex finder should not be placed in controller. We should move the complex finder to model by using named_scope.

Refactor
--------

    class Post < ActiveRecord::Base
      named_scope :matching, lambda { |column , value|
        return {} if value.blank?
        { :conditions => ["#{column} like ?", "%#{value}%"] }
      }

      named_scope :order, lambda { |order|
        {
          :order => case order
          when "title" : "title desc"
          when "created_at" : "created_at desc"
          end
        }
      }

      named_scope :limit, lambda { |limit|
        { :limit => limit }
      }
    end

    class PostsController < ApplicationController
      def search
        @posts = Post.matching(:title, params[:title])
                     .matching(:content, params[:content])
                     .order(params[:order]).limit(params[:limit])
      end
    end

The advantage to use named_scope is

  - The code is much more readable, from the method call, we can know the complex finder includes fuzzy query of title and content, order and limit.
  - Follow Skinny Controller Fat Model, this is the core principle of MVC.
  - You can easily reuse the named_scope and handle complex finders by combining small named scopes.

**updated**: in rails 3 or newer versions, you should use scope instead of named_scope.
