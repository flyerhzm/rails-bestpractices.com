---
layout: post
title: Replace Complex Creation with Factory Method
author: Wen-Tien Chang
description: Sometimes you will build a complex model with params, current_user and other logics in controller, but it makes your controller too big, you should move them into model with a factory method
tags:
- controller
- model
---
Bad Smell
---------

    class InvoicesController < ApplicationController
      def create
        @invoice = Invoice.new(params[:invoice])
        @invoice.address = current_user.address
        @invoice.phone = current_user.phone
        @invoice.vip = (@invoice.amount > 1000)

        if Time.now.day > 15
          @invoice.delivery_time = Time.now + 2.month
        else
          @invoice.delivery_time = Time.now + 1.month
        end

        @invoice.save
      end
    end

The logic to create an invoice is too complex, it makes InvoicesController a bit difficult to read. And the controller should not know too much things about how to create a model, we should move the the logic of creating an invoice into the Invoice model.

Refactor
--------

    class Invoice < ActiveRecord::Base
      def self.new_by_user(params, user)
        invoice = self.new(params)
        invoice.address = user.address
        invoice.phone = user.phone
        invoice.vip = (invoice.amount > 1000)

        if Time.now.day > 15
          invoice.delivery_time = Time.now + 2.month
        else
          invoice.delivery_time = Time.now + 1.month
        end
      end
    end

    class InvoicesController < ApplicationController
      def create
        @invoice = Invoice.new_by_user(params[:invoice], current_user)
        @invoice.save
      end
    end

Now we define a new_by_user method in Invoice model, it takes charge of the invoice creation. So the InvoicesController can just call the new_by_user method to build the invoice object.

Keep in mind the principle "Skinny Controller, Fat Model"
