---
layout: post
title: Fix N+1 Queries
author: Wen-Tien Chang (ihower@gmail.com)
description: N+1 Queries is a serious database performance problem. Be careful of that situation! If you're not sure, I recommend you install http://github.com/flyerhzm/bullet plugin, which helps you reduce the number of queries with alerts (and growl).
tags:
- model
- plugin
likes:
- pedromtavares (pedromateustavares@gmail.com)
- eric (eric@pixelwareinc.com)
- kirkvq (kirkvq@gmail.com)
- hooopo (hoooopo@gmail.com)
- alec-c4 (alec@alec-c4.com)
- Jeroen (jacobsjeroen@gmail.com)
- batasrki (spejic@gmail.com)
- jaimeiniesta (jaimeiniesta@gmail.com)
- dylanfm (dylan.fm@gmail.com)
- marshluca (marshluca@gmail.com)
- jvnill (jvnill@gmail.com)
- Codeblogger (codeblogger@gmail.com)
- dimascyriaco (dimascyriaco@gmail.com)
- akoc (aivars.akots@gmail.com)
- kylemathews (kylemathews@gmail.com)
- iceydee (mionilsson@gmail.com)
- 360andless (beanie@benle.de)
- zcq100 (zcq100@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- gri0n (lejazzeux@gmail.com)
- Deradon (deradon87@gmail.com)
- SingleShot (mike.whittemore@gmail.com)
- matthewcford (matt@bitzesty.com)
- PelCasandra (pelcasandra@me.com)
- jokry (wenglonghui@gmail.com)
- leolukin (leolukin@gmail.com)
- bugmenot (fhugfizn@sharklasers.com)
- kslagdive (kslagdive@gmail.com)
- scottweisman (scott@launchpadlab.com)
dislikes:
- 
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
