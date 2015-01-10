---
layout: post
title: Namespaced models
author: Guo Lei (guolei9@gmail.com)
description: Make the app/models more clear using namespaced models
tags:
- model
likes:
- juancolacelli (juancolacelli@gmail.com)
- dkerimdjanov (butchersenator@gmail.com)
dislikes:
- Locke23rus (locke23rus@gmail.com)
---
When the application grows bigger, it's kinda messy to keep all the models under app/models. To make the codes more readable, it makes sense to use namespaced models.

## 1. Add customized directories to autoload_paths ##

You can add as many directories as you like and then ask Rails to load the files by adding them to autoload_paths (load_paths in Rails2).

      # config/application.rb
      class Application < Rails::Application
        config.autoload_paths += %W(#{Rails.root}/app/models/pets)
      end

Now you can have dog.rb, cat.rb & any_animal_you_like.rb inside /app/models/pets directory.
Notice that the directory name can not be the same with any model's name. Otherwise there will be wired exceptions.

## 2. Put subclasses under a module ##

We all know the magic of "type" attribute. From how it works, we rarely need to call the subclass directly, so it will not cause inconvenience if we put the subclasses under a module.

    # app/models/account.rb
    class Account < ActiveRecord::Base
    end

    # app/models/user/student.rb
    class User::Student < Account
    end

    # app/models/user/admin.rb
    class User::Admin < Account
    end

In most cases, you will use Account.find(id) to get a user instance. So although the name "User::Student" is a bit longer than "Student", it will not cause much trouble but more meaningful, as well as keeping the app/models folder clear.
