---
layout: post
title: split route namespaces into different files
author: Richard Huang (flyerhzm@gmail.com)
description: the routes will become complicated with the growth of your application, contain different namespaces, each with a lot of resources and custom routes, it would be better to split routes into different files according to the namespaces, which makes it easy to maintain the complicated routes.
tags:
- route
likes:
- Leventix (bagilevi@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- jeromelefeuvre (jerome.lefeuvre@gmail.com)
- itima_ru (alexey@itima.ru)
- CvX (JRadosz@gmail.com)
- calas (calas@qvitta.net)
- zedtux (zedtux@zedroot.org)
- iktorn (iktorn@gmail.com)
- mdorfin (dorofienko@gmail.com)
- dimko (deemox@gmail.com)
- dhruvasagar.ds (dhruva.sagar@yahoo.com)
- zcq100 (zcq100@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- romanvbabenko (romanvbabenko@gmail.com)
- charlysisto (charlysisto@gmail.com)
- anga (andres.b.dev@gmail.com)
- gri0n (lejazzeux@gmail.com)
- haru01 (eiji.ienaga@gmail.com)
- jrhicks (Jrhicks@gmail.com)
- sectronov (sectronix@gmail.com)
- luis_ca (luis.ca@gmail.com)
- olistik (maurizio.demagnis@gmail.com)
- sumitasok (sumitasok@gmail.com)
- chrishein (me@christopherhein.com)
- nashiki (nashiki.shigeyuki@cyberwave.jp)
- hsps9.99 (mailme@hsps.in)
- taras (tarasst@gmail.com)
- suraj (sixstring@gmail.com)
- mayinx (mayinxx@web.de)
- xiaoronglv (xiaoronglv@hotmail.com)
- beata (nahoyabe@gmail.com)
- edgar.ortega.ramirez (edgarortegaramirez@gmail.com)
dislikes:
- 
---
I experienced that with the growth of application, the routes becomes very complicated. The following is a simple example

Before
======

    # config/routes.rb
    ActionController::Routing::Routes.draw do |map|
      map.resources :posts
      map.resources :comments
      map.logout '/logout', :controller => 'sessions', :action => 'destroy'
      map.login '/login', :controller => 'sessions', :action => 'create'

      map.namespace :developer do |dev|
        dev.resources :posts
        dev.resources :comments
        dev.logout '/logout', :controller => 'sessions', :action => 'destroy'
        dev.login '/login', :controller => 'sessions', :action => 'create'
      end

      map.namespace :admin do |admin|
        admin.resources :posts
        admin.resources :comments
        admin.logout '/logout', :controller => 'sessions', :action => 'destroy'
        admin.login '/login', :controller => 'sessions', :action => 'create'
      end
    
      map.namespace :api do |api|
        api.resources :posts
        api.resources :comments
        api.logout '/logout', :controller => 'sessions', :action => 'destroy'
        api.login '/login', :controller => 'sessions', :action => 'create'
      end
    end

In practice, there are much more routes in each namespace. As you seen, there is a default namespace (without namespace), and 3 other namespaces (developer, admin and api), the routes are complicated and very easy to add or change the route in wrong namespace, as there are some similar routes in all the namespace.

After
-----

The better solution is to split the routes into different files according namespaces.

    # config/routes.rb
    ActionController::Routing::Routes.draw do |map|
      map.resources :posts
      map.resources :comments
      map.logout '/logout', :controller => 'sessions', :action => 'destroy'
      map.login '/login', :controller => 'sessions', :action => 'create'
    end

    # config/routes/developer.rb
    ActionController::Routing::Routes.draw do |map|
      map.namespace :developer do |dev|
        dev.resources :posts
        dev.resources :comments
        dev.logout '/logout', :controller => 'sessions', :action => 'destroy'
        dev.login '/login', :controller => 'sessions', :action => 'create'
      end
    end

    # config/routes/admin.rb
    ActionController::Routing::Routes.draw do |map|
      map.namespace :admin do |admin|
        admin.resources :posts
        admin.resources :comments
        admin.logout '/logout', :controller => 'sessions', :action => 'destroy'
        admin.login '/login', :controller => 'sessions', :action => 'create'
      end
    end

    # config/routes/api.rb
    ActionController::Routing::Routes.draw do |map|
      map.namespace :api do |api|
        api.resources :posts
        api.resources :comments
        api.logout '/logout', :controller => 'sessions', :action => 'destroy'
        api.login '/login', :controller => 'sessions', :action => 'create'
      end
    end

Then you should tell rails there are 3 additional route files.

In Rails2, you can create an initializer

    # config/initializers/load_custom_routes.rb
    ActionController::Routing::Routes.add_configuration_file(Rails.root.join('config/routes/developer.rb'))
    ActionController::Routing::Routes.add_configuration_file(Rails.root.join('config/routes/admin.rb'))
    ActionController::Routing::Routes.add_configuration_file(Rails.root.join('config/routes/api.rb'))

In Rails3, you can set the configs in config/application.rb

    config.paths.config.routes.concat Dir[Rails.root.join("config/routes/*.rb")]

Now routes in different namespaces are split into different files, it is easier to maintain, I only change the developer related routes in config/routes/developer.rb, without any possible to change the rotues in admin or api namespace. Besides, rails will only reload the developer routes if you only change the config/routes/developer.rb, instead of reloading the whole routes, which may be expensive when your routes are complicated.
