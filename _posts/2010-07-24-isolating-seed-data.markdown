---
layout: post
title: Isolating Seed Data
author: Wen-Tien Chang
description: Rails 2.3.4 provides db:seed task that is the best way to insert seed data for set up a new application.
tags:
- migration
---
Bad Smell
---------

    class CreateRoles < ActiveRecord::Migration
      def self.up
        create_table "roles", :force => true do |t|
          t.string :name
        end

        ["admin", "author", "editor", "account"].each do |name|
          Role.create!(:name => name)
        end
      end

      def self.down
        drop_table "roles"
      end
    end

Before, we always insert data in migrations, which is not a good approach, it clutters up the migrations. The better way is to move all the data creations from migration files into seed.rb

Refactor
--------

    # db/seeds.rb (Rails 2.3.4)
    ["admin", "author", "editor", "account"].each do |name|
      Role.create!(:name => name)
    end

    rake db:seed

    # lib/tasks/dev.rake (before Rails 2.3.4)
    namespace :dev do

      desc "Setup seed data"
      task :setup => :environment do
        ["admin", "author", "editor", "account"].each do |name|
          Role.create!(:name => name)
        end
      end
    end

    rake dev:setup

That's it, all the seed data are concentrated in one file, it's easy to maintain.
