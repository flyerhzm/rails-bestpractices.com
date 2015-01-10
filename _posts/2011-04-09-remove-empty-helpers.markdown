---
layout: post
title: Remove empty helpers
author: Richard Huang (flyerhzm@gmail.com)
description: If you use rails generator to create scaffolds or controllers, it will also create some helpers, most of the helpers are useless, just remove them.
tags:
- helper
likes:
- flyerhzm (flyerhzm@gmail.com)
- romanvbabenko (romanvbabenko@gmail.com)
- zanst (me@zan.st)
- eparreno (emili@eparreno.com)
- viranik (kvirani@gmail.com)
- engin (shiyj.cn@gmail.com)
- Krule (armin@pasalic.com.ba)
- samir (samirbraga@gmail.com)
- zcq100 (zcq100@gmail.com)
- rafamvc (rafamvc@mailinator.com)
- juancolacelli (juancolacelli@gmail.com)
- tomthorgal (thomas.vollath@gmail.com)
- neoriddle (neopromos@gmail.com)
- beata (nahoyabe@gmail.com)
dislikes:
- Pascal Van Hecke ()
---
Rails provides very useful generators to create scaffolds, models, controllers and views, when generating the scaffolds or controllers, it also creates some helpers, some of helpers may use, but I bet most of helpers in your project are empty.

helpers are good places to add helper method for view pages, but if you don't need them, why you push these empty helpers to repository. Although your helpers are empty, rails still takes time to load them, Test::Unit or RSpec still load them to run tests.

So I recommend you to remove all the empty helpers from your project, the following is a script to detect empty helpers, remove them and corresponding unit tests or rspecs. 

    Dir.glob("app/helpers/**/*.rb").each do |file|
      if !File.read(file).index('def')
        FileUtils.rm file
        FileUtils.rm_f file.sub("app/", "test/unit/").sub(".rb", "_test.rb") if File.exists?("test")
        FileUtils.rm_f file.sub("app/", "spec/").sub(".rb", "_spec.rb") if File.exist?("spec")
      end
    end

In rails 3, you can ask rails do not generate helper automatically.

    config.generators.helper = false

It's the only bonus for rails3, it seems there's no way for rails2.
