---
layout: post
title: Name your model methods after their behavior, not implementation.
author: Brasten Sager (brasten@brasten.me)
description: Business model methods should be named after the logic / business value they provide, not the implementation details. Violations to this practice tend to show up on ActiveRecord models.
tags:
- models
likes:
- juancolacelli (juancolacelli@gmail.com)
- alauper (adamlauper@gmail.com)
dislikes:
- 
---
 Before
------

Your business model is not the same thing as your data-access pattern.

(Unless your in the business of developing ORM frameworks, then maybe it is)

Most business-model classes in a Rails application subclass ActiveRecord::Base -- something for a future Best Practice to talk about. As such, business logic often gets mixed up with persistence logic. This results in methods that go to great lengths to tell me HOW they might fullfil my request, but often fail to describe what exactly they’re useful for.

Here’s an example from a project I’m working on now:


    class Device
    
      class << self
        # provisions a new device for the user
        #
        def find_and_update_or_reassign_or_create( user, attributes )
          # ...
        end
      end
    end

There’s actually a lot of logic code in this method, and it turns out it is pretty core to our business logic. But what does it do? All I can tell you for sure is it will probably perform 2 or 3 DB operations … but when working with a business model, why do I care about that?

Refactor
--------

Persistence is something your business model does for you, when necessary. How it does it may be important at some level, but at the top-level business model it probably shouldn't be.

Instead, name your method based on the business function it performs:

    class Device
    
      class << self
        # provisions a new device for the user
        #
        def provision( user, attributes )
          # ...
        end
      end
    end

Refactored!
