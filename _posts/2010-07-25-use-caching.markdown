---
layout: post
title: Use caching !
author: Gregory Durelle
description: Using the cache will speed up your application response time a lot. In fact, when people will request your pages, rails won't be requested, apache will serve the cached pages, thus double advantage, faster pages response time Lower charge on your server
tags:
- cache
---
Caching is really simple, see page caching.

In your production.rb file add :

    config.action_controller.perform_caching = true
    config.action_controller.cache_store = :file_store, RAILS_ROOT+"/tmp/cache/"
    config.action_controller.page_cache_directory = RAILS_ROOT+"/public/cache/"

And in the controllers where you want to activate page caching just add :

    caches_page :index, :help, :home, :faq

And that's it !
Next time you'll access the cached pages without requesting your rails server.

For more advanced info just read the guide :

[http://guides.rubyonrails.org/caching_with_rails.html][1]


  [1]: http://guides.rubyonrails.org/caching_with_rails.html
