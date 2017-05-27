---
layout: post
title: Use model callback
author: Wen-Tien Chang
description: Use model callback can avoid writing some logic codes in controller before or after creating, updating and destroying a model.
tags:
- controller
- model
---
Bad Smell
---------

    <% form_for @post do |f| %>
      <%= f.text_field :content %>
      <%= check_box_tag 'auto_tagging' %>
    <% end %>

    class PostsController < ApplicationController
      def create
        @post = Post.new(params[:post])

        if params[:auto_tagging] == '1'
          @post.tags = AsiaSearch.generate_tags(@post.content)
        else
          @post.tags = ""
        end

        @post.save
      end
    end

In this example, if user clicks the checkbox auto_tagging, we will generate tags according to the content of post, then assign the tags to the post before saving the post. We can move the tags assignment codes into the model by using model callback.

Refactor
--------

    class Post < ActiveRecord::Base
      attr_accessor :auto_tagging
      before_save :generate_tagging

      private
      def generate_taggings
        return unless auto_tagging == '1'
        self.tags = Asia.search(self.content)
      end
    end

    <% form_for @post do |f| %>
      <%= f.text_field :content %>
      <%= f.check_box :auto_tagging %>
    <% end %>

    class PostsController < ApplicationController
      def create
        @post = Post.new(params[:post])
        @post.save
      end
    end

As you see, we create a before_save callback generate_tagging in Post model, it generates and assigns tags if user clicks the auto_tagging checkbox. Then PostsController has no needs to take care of the model logic.
