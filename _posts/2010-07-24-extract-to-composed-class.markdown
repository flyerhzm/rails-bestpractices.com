---
layout: post
title: Extract to composed class
author: Wen-Tien Chang (ihower@gmail.com)
description: If a model has some related columns, e.g. a user has an address_city and an address_street, you can extract these properties into a composed class.
tags:
- model
likes:
- ihower (ihower@gmail.com)
- eric (eric@pixelwareinc.com)
- wuyh (wyh770406@gmail.com)
- wuyh (wyh770406@gmail.com)
- wuyh (wyh770406@gmail.com)
- wuyh (wyh770406@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
dislikes:
- 
---
Bad Smell
---------

    # == Schema Information
    #  address_city        :string(255)
    #  address_street      :string(255)
    class Customer < ActiveRecord::Base
      def address_close_to?(other_customer)
        address_city == other_cutomer.address_city
      end
    
      def address_equal(other_customer)
        address_street == other_customer.address_street &&
          address_city == other_customer.address_city
      end
    end

You can see that a Customer model has two properties address_city and address_street, but address_city and address_street should be the property in Address class. If you don't want to create a addresses table, you can just create a composed class Address.

Refactor
--------

    class Customer < ActiveRecord::Base
      composed_of :address, :mapping => [ %w(address_street street), %w(address_city city)]
    end
    
    class Address
      attr_reader :street, :city
    
      def initialize(street, city)
        @street, @city = street, city
      end
    
      def close_to?(other_address)
        city == other_address.city
      end
    
      def ==(other_address)
        city == other_address.city && street == other_address.street
      end
    end

Rails provides a helper method composed_of to make it easy to extract a composed class. Here we add a composed class Address to the model Customer, in Address model we use property street and city and in Customer model they are corresponding to address_street and address_city. Each property goes to its own class.
