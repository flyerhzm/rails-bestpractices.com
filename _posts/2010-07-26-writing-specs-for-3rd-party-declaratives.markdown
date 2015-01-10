---
layout: post
title: Writing specs for 3rd party declaratives
author: Ng Tze Yang (ngty77@gmail.com)
description: Using declaratives (eg. acts_as_authentic) provided by external libs is unavoidable in building a rails application. But testing 3rd party libs is surely not part of our work, yet how do we rest assured that these declaratives are called ??
tags:
- rspec
likes:
- flyerhzm (flyerhzm@gmail.com)
dislikes:
- eric (eric@pixelwareinc.com)
- riethmayer (jan@riethmayer.de)
- fireflyman (yangxiwenhuai@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
---
Rule of thumb, never ever test 3rd party (external) libs, unless u suspect the lib is buggy, and want to prove to the lib author(s). Yet, we need to have a way to ensure the declaratives are called. Here's what i do to stike a balance:

    # app/models/user.rb
    model User < ActiveRecord::Base
      acts_as_authentic
    end

    # spec/models/user_spec.rb
    describe User do
      include RailsBestPractices::Macros
      should_act_as_authentic
    end

Building upon wat we already have in [write ur own spec macros][1]:

    # spec/macros.rb
    module RailsBestPractices::Macros::ClassMethods

        def should_act_as_authentic
           should_include_module 'should be acting as authentic', /Authlogic::ActsAsAuthentic::/
        end
           
        private
             
          def should_include_module(description, module_name_or_regexp)

             # Calling of 3rd party declarative usually have the side effect of including extra module(s)
             # from the lib, we want to ignore the ones included by a basic model (with no declaratives called),
             # and grab only those extra modules, specific for the context class
             basic_included_modules = Class.new(ActiveRecord::Base).included_modules
             klass_included_modules = context_klass.included_modules
             extra_modules = (klass_included_modules - basic_included_modules).map(&:to_s)

             it(description) do
               case module_name_or_regexp
               when Regexp
                 extra_modules.any?{|mod| mod =~ module_name_or_regexp }.should be_true
               else
                 extra_modules.should include(module_name_or_regexp.to_s)
               end
             end
          end

    end

  [1]: http://rails-bestpractices.com/posts/30-write-ur-own-spec-macros
