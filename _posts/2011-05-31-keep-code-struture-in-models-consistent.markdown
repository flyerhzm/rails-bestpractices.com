---
layout: post
title: Keep code struture in models consistent
author: Guo Lei
description: When the business logic of models becomes complex, it's very helpful to keep a consistent code structure that is agreed by team members.
tags:
- model
---
Following Rails conventions, life is happy. It can be happier if we create conventions for codes in models, especially when there's multiple programmers working on the same model.

One example:
(From top to bottom)

 1. associations
 2. scopes
 3. class methods
 4. validates
 5. callbacks
 6. instance methods

Code example:

    class Article < ActiveRecord::Base
      has_many :comments
      belongs_to :author

      default_scope order("id desc")
      scope :published, where(:published => true)
      scope :created_after, lambda{|time| ["created_at >= ?", time]}

      class << self
        def batch_create(data)
          # ...
        end
      end

      validates :title, :presence => true

      before_create :init_score
      def init_score
        self.score = 10
      end

      def any_instance_method
        # ...
      end

      begin "score related functions" # Group functions by begin .. end
        def add_score(score)
          # ...
        end
      end

    end





