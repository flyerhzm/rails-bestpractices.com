---
layout: post
title: split your cap tasks into different files
author: Richard Huang (flyerhzm@gmail.com)
description: Your capistrano deploy.rb file might become complicated with the growth of your application, contain more and more cap tasks, it would be better to split these tasks into different files according to the functionalities, which makes it easy to maintain, and they are more likely to be reused in the future.
tags:
- deployment
- capistrano
likes:
- flyerhzm (flyerhzm@gmail.com)
- chrishein (me@christopherhein.com)
- marocchino (marocchino@gmail.com)
- rgo (contacto@rafagarcia.net)
- ck3g (kalastiuz@gmail.com)
- Mike (mike@odania-it.de)
- xanbei (xanbei@gmail.com)
dislikes:
- 
---
I worked on a large project, it contains a lot of capistrano tasks, which makes it more and more difficult to maintain.

## Before

After application grows, I saw too much tasks written in config/deploy.rb file, it was messy. e.g.

    # config/deploy.rb
    require 'capistrano_colors'
    require 'bundler/capistrano'

    set :user, 'huangzhi'
    ......
    role :web, "app.example.com"
    role :app, "app.example.com"
    role :db,  "db.example.com", :primary => true

    after "deploy", "cron:update"
    after "deploy", "sitemap:refresh"
    set :assets_dependencies, %w(app/assets lib/assets vendor/assets Gemfile.lock config/routes.rb)
    
    namespace :cron do
      task :update do
        update_app
        update_db
      end
      task :update_app do
        # update cron jobs on app servers
      end
      task :update_db do
        # update cron jobs on db servers
      end
    end

    namespace :sitemap do
      task :refresh, :roles => :app do
        # generate sitemap.xml for SEO
      end
    end

    namespace :deploy do
      namespace :assets do
        task :precompile, :roles => :web, :except => { :no_release => true } do
          # precompile asset only when asset changes
        end
      end
    end

    namespace :deploy do
      task :start do ; end 
      task :stop do ; end 
      task :restart, :roles => :app, :except => { :no_release => true } do
        # restart app servers
      end
    end

## After

Inspired by require external capistrano recipes (like bundler and rvm), I prefer splitting the tasks into different files according to the functionalities, like

    # config/deploy/recipes/asset_pipeline.rb
    set :assets_dependencies, %w(app/assets lib/assets vendor/assets Gemfile.lock config/routes.rb)

    namespace :deploy do
      namespace :assets do
        task :precompile, :roles => :web, :except => { :no_release => true } do
          # precompile asset only when asset changes
        end
      end
    end

    # config/deploy/recipes/cron.rb
    after "deploy", "cron:update"

    namespace :cron do
      task :update do
        update_app
        update_db
      end
      task :update_app do
        # update cron jobs on app servers
      end
      task :update_db do
        # update cron jobs on db servers
      end
    end

    # config/deploy/recipes/sitemap.rb
    after "deploy", "sitemap:refresh"

    namespace :sitemap do
      task :refresh, :roles => :app do
        # generate sitemap.xml for SEO
      end
    end

We have 3 capistrano recipes, asset_pipeline, cron and sitemap, each with one functionality, and then you can easily load them in config/deploy.rb.

    # config/deploy.rb
    require 'capistrano_colors'
    require 'bundler/capistrano'
    
    set :user, 'huangzhi'
    ......
    role :web, "app.example.com"
    role :app, "app.example.com"
    role :db,  "db.example.com", :primary => true

    load 'config/deploy/recipes/asset_pipeline'
    load 'config/deploy/recipes/cron'
    load 'config/deploy/recipes/sitemap'

    namespace :deploy do
      task :start do ; end 
      task :stop do ; end 
      task :restart, :roles => :app, :except => { :no_release => true } do
        # restart app servers
      end
    end

config/deploy.rb looks pretty clean now.

Furthermore, you can autoload custom recipes by changing following code in Capfile

    Dir['vendor/plugins/*/recipes/*.rb', 'config/deploy/recipes/*.rb'].each { |plugin| load(plugin) }

You can easily create your own capistrano recipes like this and reuse them in the next projects.

Thank **chrishein** to share the idea to autoload custom recipes.
