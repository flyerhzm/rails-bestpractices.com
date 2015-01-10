---
layout: post
title: Always add DB index
author: Wen-Tien Chang (ihower@gmail.com)
description: Always add index for foreign key, columns that need to be sorted, lookup fields and columns that are used in a GROUP BY. This can improve the performance for sql query.  If you're not sure which column need to index , I recommend to use http://github.com/eladmeidar/rails_indexes, which provide rake tasks to find missing indexes.
tags:
- migration
likes:
- ihower (ihower@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- Ninad Pachpute (ninadpachpute@gmail.com)
- eric (eric@pixelwareinc.com)
- ixandidu (ixandidu@gmail.com)
- hooopo (hoooopo@gmail.com)
- AndrÃ© Moreira ã‚ªã‚¿ã‚¯ ()
- sameera207 (sameera207@gmail.com)
- neutrino (ranendra@sprout-technology.com)
- iGEL (igel@igels.net)
- regedor (miguelregedor@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- des (Ijon57@gmail.com)
- logankoester (logan@logankoester.com)
- PelCasandra (pelcasandra@me.com)
- leolukin (leolukin@gmail.com)
- bugmenot (fhugfizn@sharklasers.com)
dislikes:
- madeofcode (markdodwell@gmail.com)
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
