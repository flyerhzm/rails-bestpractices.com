---
layout: post
title: Extract into Module
author: Wen-Tien Chang
description: Some codes in your model are related, they are take charge of the same things, such as logging and authorization. We can extract these codes into a module to reuse them.
tags:
- model
---
It is not exactly a code smell, it is an improvement.

Before Refactor
---------------

    class User < ActiveRecord::Base
      validates_presence_of :cellphone
      before_save :parse_cellphone

      def parse_cellphone
        # do something
      end
    end

As you see, User model has a presence validation of cellphone and a before save callback parse_cellphone, they are related and can be abstracted into a module.

After Refactor
--------------

    module HasCellphone
      def self.included(base)
        base.validates_presence_of :cellphone
        base.before_save :parse_cellphone
      end

      def parse_cellphone
        # do something
      end
    end

    class User < ActiveRecord::Base
      include HasCellphone
    end

Now we extract the cellphone related validation and  callback into the HasCellphone module, so we can only include HasCellphone module in User model to add the ability of validation and callback.
