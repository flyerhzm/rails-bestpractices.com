---
layout: post
title: Restrict auto-generated routes.
author: Andy Wang
description: By default, Rails generates seven RESTful routes(new,edit,create,destroy,index,show, update) for a resource, sometime the resource only needs one or two routes, so just user :only or :except while defining routes to speedup the routing.
tags:
- route
- rails
- RESTful
---
For instance, you've got a comments_controller, and your application only needs its "create" and "destroy" actions. How will you define your routes?

**Normally, people will do:**

    resources :comments

This will generate seven routes for you by Rails' default. Such as:

    comments      GET       /comments(.:format)
                  POST      /comments(.:format)
    new_comment   GET       /comments/new(.:format)
    edit_comment  GET       /comments/:id/edit(.:format)
    comment       GET       /comments/:id(.:format)
                  PUT       /comments/:id(.:format)
                  DELETE    /comments/:id(.:format)

**Refactor:**

    resources :comments, :only => [:create, :destroy]

New generated routes are only two:

                  POST      /comments(.:format)
                  DELETE    /comments/:id(.:format)


Comparing to :only, the :except option also works well to EXCEPT the included routes.

If your application defines many reoutes, the above restricting on routes will delete many useless routes, that means cutting down on memory use for you and speeding up the routing process.

Simple but a good habit!
Enjoy it.
