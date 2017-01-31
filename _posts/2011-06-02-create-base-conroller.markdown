---
layout: post
title: Create base controller 
author: Guo Lei (guolei9@gmail.com)
description: Have base controllers for DRY
tags:
- controller
likes:
- romanvbabenko (romanvbabenko@gmail.com)
- seyyah (seyyah@bil.omu.edu.tr)
- alauper (adamlauper@gmail.com)
dislikes:
- tim.linquist (tim.linquist@gmail.com)
- shishir (shishir.das@gmail.com)
- zcq100 (zcq100@gmail.com)
- kelin1234 (account.name@live.cn)
- juancolacelli (juancolacelli@gmail.com)
- DanBlack (klobor@yandex.ru)
---

To keep codes clear, we usually put controllers with same business scope into the same directory. In most cases, these controllers will share some functions, so we can create a base controller for them for DRY. 

For example, we have a list of controllers for content management:

    admin
      content
        articles_controller
        comments_controller
        scores_controller
      other
        others_controller

Normally, controllers under admin directory should require current_user to be an admin, so we need to add `before_filter :admin_required` for each controller. Where's the best place to do this? The "base" controller for admin.

The file structure after adding base controllers:
   
    admin
      content
         articles_controller.rb
         comments_controller.rb
         scores_controller.rb
         base_controller.rb
      other
         others_controller.rb
      base_controller.rb

Example codes for admin/base_controller

    class Admin::BaseController < ApplicationController
      before_filter :admin_required
      protected
      def admin_required
        # implementation
      end
    end

Example codes for admin/content/base_controller

    class Admin::Content::BaseController < Admin::BaseController
      before_filter :find_article
      protected
      def find_article
        @article = Article.find_by_id(params[:id])
      end
    end

For controllers under admin/content, they just need to inherit from admin/content/base_controller.

Some examples that can (and should) be put in base controllers:

 1. Access controll
 2. layout selector
 3. Initialize variables that will be used in most actions. (like @article in the above example)

 
