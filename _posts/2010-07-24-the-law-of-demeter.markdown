---
layout: post
title: the Law of Demeter
author: Wen-Tien Chang
description: According to the law of demeter, a model should only talk to its immediate association, don't talk to the association's association and association's property, it is a case of loose coupling.
tags:
- model
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
