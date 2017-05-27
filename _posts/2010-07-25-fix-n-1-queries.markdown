---
layout: post
title: Fix N+1 Queries
author: Wen-Tien Chang
description: N+1 Queries is a serious database performance problem. Be careful of that situation! If you're not sure, I recommend you install http://github.com/flyerhzm/bullet plugin, which helps you reduce the number of queries with alerts (and growl).
tags:
- model
- plugin
---
Sample Model code
---------

    # model
    class User < ActieRecord::Base
        has_one :car
    end
    -
    class Car < ActiveRecord::Base
        belongs_to :user
    end

Bad Smell
---------

    # your controller
    def index
      @users = User.paginate( :page => params[:page], :per_page => 20 )
    end

    # view
    <% @users.each do |user| %>
       <%= user.car.name %>
    <% end %>

When @users.each in view, it cause N+1 queries. (N is 20 in this case)

Refactor
--------

    # your controller
    def index
      @users = User.paginate( :include => :car, :page => params[:page], :per_page => 20 )
    end

Add :include into query, so the number of queries reduces to only 2.
