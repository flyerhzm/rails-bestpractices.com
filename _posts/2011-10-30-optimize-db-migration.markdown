---
layout: post
title: Optimize db migration
author: Richard Huang (flyerhzm@gmail.com)
description: rails migration provides a convenient way to alter database structure, you can easily add, change and drop column to a existing table, but when the data in existing table are huge, it will take a long time to alter existing table, you should try to merge/optimize the db alter sql statements.
tags:
- migration
- performance
likes:
- flyerhzm (flyerhzm@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- Dmitry Nesteruk ()
- PsiCat (ogealter@gmail.com)
dislikes:
- alauper (adamlauper@gmail.com)
---
Nowadays it's easy to reach millions users for a startup website due to sns success, that means the tables on production server are huge, if you want to alter table structure, like add a new column, it may takes tens of minutes or several hours to execute.

If you want to add a new column and drop an existing column to one existing table, by default rails migration will run two alter sql statements, one for add and the other for drop, so it takes double time, but if we merge/optimize the two alter sql statements into one, it saves the migration time dramatically.

The followings two are the typical cases to optimize the db migrations.

Case 1: add a new column but drop it later
----------------------------------------------------------

db/migrate/20110930100808_add_status_to_users

    class AddStatusToUsers < ActiveRecord::Migration
      def self.up
        add_column :users, :status, :string
      end
    end

db/migrate/20111010100909_remove_status_from_users

    class RemoveStatusToUsers < ActiveRecord::Migration
      def self.up
        remove_column :users, :status
      end
    end

In development we add the column status to table users and remove it later because of requirement changed, if we deploy by capistrano, these two migrations will take tens of minutes (if you have million users), at the mean time, the users table will be locked. But actually there is no necessary to execute these two migrations when deploying to production server.

You may think to simply delete these two migrations, please don't do that, it may break other developers' local database structure. What we should do is to tell rails migration to skip these two migrations when running "rake db:migration" on production server. Rails uses schema_migrations to indicate which migrations are executed or not, so we can manually update the schema_migrations indexes, in this case, we should run

    INSERT INTO `schema_migrations` VALUES ('20110930100808')
    INSERT INTO `schema_migrations` VALUES ('20111010100909')

on production database. After that, when we deploy the codes to production server, these two migrations will be skipped.

Case 2: multiple alter table sql statements
-------------------------------------------------------------

db/migrate/20111002101010_remove_location_fom_users

    class RemoveLocationFromUsers < ActiveRecord::Migration
      def self.up
        remove_column :users, :location
      end
    end

db/migrate/20111003101010_add_gender_from_users

    class AddGenderToUsers < ActiveRecord::Migration
      def self.up
        add_column :users, :gender, :string
      end
    end

ok, before next deployment, we remove a column location and add a column gender to users table, they will execute two table alter sql statements

    ALTER TABLE `users` DROP COLUMN location
    ALTER TABLE `users` ADD COLUMN gender varchar(255) DEFAULT NULL

Let's assume add a column and remove a column to users table take 1 hour for each, so it will take totally 2 * 1 = 2 hours to execute these two migrations, but if we can merge these two table alter sql statements into one, it only takes about 1 hour to execute. So we should create two additional migrations to save production migration time.

db/migrate/20111011040404_add_location_and_remove_gender_to_users

    class AddLocationAndRemoveGenderToUsers < ActiveRecord::Migration
      def self.up
        add_column :users, :location, :string
        remove_column :users, :gender
      end
    end

db/migrate/20111011050505_remove_location_and_add_gender_to_users

    class RemoveLocationAndAddGenderToUsers < ActiveRecord::Migration
      def self.up
        connection.execute("ALTER TABLE `users` DROP COLUMN location, ADD COLUMN gender varchar(255) DEFAULT NULL")
      end
    end

When running "rake db:migrate" during production deployment, we should skip first 3 migrations and execute only the last migration, so manually update the schema_migrations index as follows

    insert into `schema_migrations` VALUES ('20111002101010')
    insert into `schema_migrations` VALUES ('20111003101010')
    insert into `schema_migrations` VALUES ('20111011040404')

if you are using rails 3.1, you can use change_table with :bulk => true option to execute bulk alter

    class RemoveLocationAndAddGenderToUsers < ActiveRecord::Migration
      def self.up
        change_table :users, :bulk => true do |t|
          t.remove :location
          t.string :gender
        end
      end
    end

And finally, don't forget to add comments to these optimized migrations so that other developers will not be  confused with them.
