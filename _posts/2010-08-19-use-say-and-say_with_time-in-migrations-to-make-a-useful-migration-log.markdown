---
layout: post
title: Use say and say_with_time in migrations to make a useful migration log
author: Guillermo Álvarez Fernández
description: Use say_with_time and say in migrations will produce a more readable output in migrations. And if use correctly it could be a helpful friend when something goes wrong because normally it is stored in the deploy log
tags:
- migration
---
Is a good practice to use **say_with_time** and **say** in migrations. When doing multiple things in a migration it is more explanatory than just show the name of the file.

For example, imagine you have a migration that just update column information for all users.

## Example ##

    class UpdateUsersNames < ActiveRecord::Migration
      def self.up
        say_with_time("Spliting name to extract last name") do
          User.find_each do |user|
            user.firstname, user.lastname = name.match(/^([^\s]*)\s*(.*)$/).to_a[1..-1] unless user.lastname.present?
            if user.changed?
              user.save
              say "#{user.id} was updated", subitem: true
            end
          end
        end
      end

      def self.down
      end
    end

## Produce ##

    ==  UpdateUserName: migrating =================================================
    -- Spliting name to extract last name
       -- 859302 was updated
       -- 859303 was updated
       -> 0.0786s
    ==  UpdateUserName: migrated (0.0787s) ========================================



