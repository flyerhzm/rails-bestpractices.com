---
layout: post
title: abuse content_for
author: Jim Ruther Nill (jvnill@gmail.com)
description: Use content_for for grouping html contents like javascript and css
tags:
- view
likes:
- ninyanernel (npdepolonia@gmail.com)
- eric (eric@pixelwareinc.com)
- AndrÃ© Moreira ã‚ªã‚¿ã‚¯ ()
- kylemathews (kylemathews@gmail.com)
- Locke23rus (locke23rus@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- simon.brandhof (simon.brandhof@gmail.com)
dislikes:
- qichunren (whyruby@gmail.com)
---
you should have a

    <%= yield :head %>

line in your head tag so you can do

    <% content_for :head do %>
      <%= javascript_include_tag 'foo', 'bar' %>
      <% javascript_tag do %>
        page specific javascript here
      <% end %>
    <% end %>

in any page you like to include a javascript/css file.  This way, all js and css files/code is found in the head tag of your page.


In the same way, you can have a partial that renders the sidebar of your application.  In that partial, you can have

    # Common sidebar items here
    # Common sidebar items here
    
    # Dynamic sidebar items here
    <%= yield :sidebar %>

so you can have dynamic sidebar content by just adding

    <% content_for :sidebar do %>
      page specific sidebar content
    <% end %>


