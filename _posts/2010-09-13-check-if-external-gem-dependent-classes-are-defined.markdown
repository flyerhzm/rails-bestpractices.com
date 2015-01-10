---
layout: post
title: Check if external gem-dependent classes are defined 
author: Bartosz Pietrzak (bartosz@monterail.com)
description: If you have to set some external gem's config options in /config/enviroment.rb, contain it within `if defined?` block
tags:
- rails2
- config
- gems
- gem
- initializers
likes:
- bartosz (bartosz@monterail.com)
- juancolacelli (juancolacelli@gmail.com)
dislikes:
- Artur Roszczyk ()
---
**How it should be done**

First of all - you should setup your gems options in `/config/initializers.rb`, eg. in `/config/initializers/calendar_date_select_options.rb`

But if you really have to do it in `/config/enviroment.rb`...

**Bad practice**

    CalendarDateSelect.format = :finnish

**Good practice**

    if defined? CalendarDateSelect
      CalendarDateSelect.format = :finnish
    end

This won't break others' attempt to launch `rake gems:install`.


