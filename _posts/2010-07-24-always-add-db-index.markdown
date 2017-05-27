---
layout: post
title: Always add DB index
author: Wen-Tien Chang
description: Always add index for foreign key, columns that need to be sorted, lookup fields and columns that are used in a GROUP BY. This can improve the performance for sql query.  If you're not sure which column need to index , I recommend to use http://github.com/eladmeidar/rails_indexes, which provide rake tasks to find missing indexes.
tags:
- migration
---
Bad Smell
---------

    class CreateComments < ActiveRecord::Migration
      def self.up
        create_table "comments" do |t|
          t.string :content
          t.integer :post_id
          t.integer :user_id
        end
      end

      def self.down
        drop_table "comments"
      end
    end

By default, rails does not add indexes automatically for foreign key, you should add indexes by yourself.

Refactor
--------

    class CreateComments < ActiveRecord::Migration
      def self.up
        create_table "comments" do |t|
         t.string :content
         t.integer :post_id
         t.integer :user_id
        end

        add_index :comments, :post_id
        add_index :comments, :user_id
      end

      def self.down
        drop_table "comments"
      end
    end

This is a basic practice, follow it.
