---
layout: post
title: Write ur own spec macros
author: Ng Tze Yang (ngty77@gmail.com)
description: Macro-writing is a great way to keep ur specs beautiful, compact & readable, & keeps specs writing fun. Macro-writing isn't rocket science, everyone can do it (almost, i think).
tags:
- rspec
likes:
- flyerhzm (flyerhzm@gmail.com)
dislikes:
- eric (eric@pixelwareinc.com)
- juancolacelli (juancolacelli@gmail.com)
---
Let's start with a simple model:
    
    class Implementation < ActiveRecord::Base

      belongs_to :user

      def belongs_to?(user)
        user && user_id == user.id
      end      

    end

The original specs is:

    describe Implementation do
      
      should_belong_to :user

      it 'should belong to someone if he is the owner of it' do
        someone = Factory(:user)
        Factory(:implementation, :user => someone).belongs_to?(someone).should be_true
      end

      it 'should not belong to someone if he is not the owner of it' do
        someone = Factory(:user)
        Factory(:implementation).belongs_to?(someone).should be_false
      end
  
    end

What we want to achieve eventually, after implementing our home-baked macro is something like this:

    describe Implementation do
      include RailsBestPractices::Macros
      should_be_user_ownable
    end

Here's what we can do:

    # spec/macros.rb
    module RailsBestPractices
      module Macros

        def self.included(base)
          base.extend(ClassMethods)
        end  

        module ClassMethods

          def should_be_user_ownable(factory_id = nil)
            factory_id ||= default_factory_id
            
            # define an example group
            describe 'being user ownable' do

              should_belong_to :user

              it 'should belong to someone if he is the owner of it' do
                someone = Factory(:user)
                Factory(factory_id, :user => someone).belongs_to?(someone).should be_true
              end

              it 'should not belong to someone if he is not the owner of it' do
                someone = Factory(:user)
                Factory(factory_id).belongs_to?(someone).should be_false
              end

           end
         end

         private
           
           def default_factory_id
              context_klass.to_s.tableize.singularize.to_sym
           end

           def context_klass
             self.description.split('::').inject(Object) {|klass, const| klass.const_get(const) }
           end

         end
       end
    end

And making sure the macro definitions file is required:

    # spec/spec_helper.rb
    # (bottom)
    require File.join(File.dirname(__FILE__), 'macros')

That's all !!

**NOTE**: It is actually very easy to amend the macro definition to work for test/unit or minitest, but that can be left as an exercise for the reader i guess. Feel free to ping me if u need help :]
  
