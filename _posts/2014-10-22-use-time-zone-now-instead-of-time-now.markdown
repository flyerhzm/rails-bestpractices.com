---
layout: post
title: Use Time.zone.now instead of Time.now
author: Dan Kohn (dan@dankohn.com)
description: The ActiveSupport method Time.zone.now should be used in place of the Ruby method Time.now to pickup the local time zone.
tags:
- time
- Time Zones
likes:
- alexey.shein.1 (alexey@besmarty.ru)
dislikes:
- pftg (paul.nikitochkin@gmail.com)
---
## Before

Using default Ruby `Time`, `Date` and `DateTime` classes will not show times in the time zone specified by `config.time_zone` in `application.rb`. 

    Time.zone = "Alaska"
    Time.now
    Date.today

These show the local time, not the time in Alaska (unless you're already in Alaska).

## Refactor

You should instead use ActiveSupport methods of `Time.zone` to pickup the Rails time zone.

    Time.zone.now
    Time.zone.today

This is well-described in [The Exhaustive Guide to Rails Time Zones](http://danilenko.org/2012/7/6/rails_timezones/). This should be easy to write a `rails_best_practice` rule to implement.

Time zone bugs are particularly tricky when the production server is set to a different time zone (often UTC) than the development machine. Using 'Time.zone` avoids this breakdown of dev/prod parity.
