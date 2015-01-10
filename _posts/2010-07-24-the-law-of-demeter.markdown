---
layout: post
title: the Law of Demeter
author: Wen-Tien Chang (ihower@gmail.com)
description: According to the law of demeter, a model should only talk to its immediate association, don't talk to the association's association and association's property, it is a case of loose coupling.
tags:
- model
likes:
- ihower (ihower@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- xijo (xijo@gmx.de)
- marshluca (marshluca@gmail.com)
- Jamison Dance ()
- jaimeiniesta (jaimeiniesta@gmail.com)
- avocade (avocade@gmail.com)
- leobessa (leobessa@gmail.com)
- leobessa (leobessa@gmail.com)
- regedor (miguelregedor@gmail.com)
- austinthecoder (austinthecoder@gmail.com)
- des (Ijon57@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- vosechu (vosechu@gmail.com)
- lukec (luke@talesa.net)
- nathanvda (nathan@dixis.com)
- cirdes (cirdes@gmail.com)
- sadfuzzy (sadfuzzy@yandex.ru)
- huacnlee (huacnlee@gmail.com)
- regedarek (darek.finster@gmail.com)
- jasperkennis (jasper@fontanel.nl)
- thelastinuit (thelastinuit@bravarianpawstudios.com)
- bugmenot (fhugfizn@sharklasers.com)
- berkes (rails-bestpractices@berk.es)
- cedric (cedric_chenzhong@163.com)
- ahmad.alkheat.5 (wisamfaithful@gmail.com)
dislikes:
- eric (eric@pixelwareinc.com)
- Alfuken ()
---
Bad Smell
---------

    class Invoice < ActiveRecord::Base
      belongs_to :user
    end
    
    <%= @invoice.user.name %>
    <%= @invoice.user.address %>
    <%= @invoice.user.cellphone %>

In this example, invoice model calls the association(user)'s property(name, address and cellphone), which violates the law of demeter. We should add some wrapper methods.

Refactor
-------

    class Invoice < ActiveRecord::Base
      belongs_to :user
      delegate :name, :address, :cellphone, :to => :user, :prefix => true
    end
    
    <%= @invoice.user_name %>
    <%= @invoice.user_address %>
    <%= @invoice.user_cellphone %>

Luckily, rails provides a helper method delegate which utilizes the DSL way to generates the wrapper methods. Besides the loose coupling, delegate also prevents the error call method on nil object if you add option :allow_nil => true.
