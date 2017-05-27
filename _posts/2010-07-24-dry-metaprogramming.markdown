---
layout: post
title: DRY Metaprogramming
author: Wen-Tien Chang
description: If you find some methods whose definitions are similar, only different by the method name, it may use meta programming to simplify the things.
tags:
- model
---
Bad Smell
---------

    class Post < ActiveRecord::Base
      validate_inclusion_of :status, :in => ['draft', 'published', 'spam']

      def self.all_draft
        find(:all, :conditions => { :status => 'draft' }
      end

      def self.all_published
        find(:all, :conditions => { :status => 'published' }
      end

      def self.all_spam
        find(:all, :conditions => { :status => 'spam' }
      end

      def draft?
        self.status == 'draft'
      end

      def published?
        self.status == 'published'
      end

      def spam?
        self.status == 'spam'
      end
    end

In this example, we have the similar method definitions of all_draft, all_published, all spam and draft?, published?, spam?, their differences are dependent on the method name, more precisely, dependent on the different status. We can simplify the codes by using meta programming.

Refactor
--------

    class Post < ActiveRecord::Base

      STATUSES = ['draft', 'published', 'spam']
      validate_inclusion_of :status, :in => STATUSES

      class <<self
        STATUSES.each do |status_name|
          define_method "all_#{status_name}" do
            find(:all, :conditions => { :status => status_name }
          end
        end
      end

      STATUSES.each do |status_name|
        define_method "#{status_name}?" do
          self.status == status_name
        end
      end

    end

It is much cleaner to use the meta programming to dynamic define the methods, besides this, it is much easier to meet the changes, if some statuses are added, changed or removed, what you should do is to change the constants STATUSES.

Updated: thanks @funny_falcon
