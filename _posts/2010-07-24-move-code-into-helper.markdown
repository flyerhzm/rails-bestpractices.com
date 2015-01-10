---
layout: post
title: Move code into helper
author: Wen-Tien Chang (ihower@gmail.com)
description: According to MVC architecture, there should not be logic codes in view, in this practice, I will introduce you to move codes into helper.
tags:
- view
- helper
likes:
- ihower (ihower@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- eric (eric@pixelwareinc.com)
- kirkvq (kirkvq@gmail.com)
- sprysoft (david@spry-soft.com)
- AndrÃ© Moreira ã‚ªã‚¿ã‚¯ ()
- cash (ashley.c.woodard@gmail.com)
- madeofcode (markdodwell@gmail.com)
- kimptoc (chris@kimptoc.net)
- juancolacelli (juancolacelli@gmail.com)
- tarasevich (tarasevich.a@gmail.com)
- SirRamonGabriel (sirramongabriel@gmail.com)
dislikes:
- dw (dear.mr.dw@gmail.com)
---
Bad Smell
---------

    <%= select_tag :state, options_for_select( [[t(:draft), "draft"],
                                                [t(:published), "published"]],
                                               params[:default_state] ) %>

The options for state select is a bit complex in view, let's move it into helper.

Refactor
--------

    <%= select_tag :state, options_for_post_state(params[:default_state]) %>
    
    # app/helpers/posts_helper.rb
    def options_for_post_state(default_state)
      options_for_select( [[t(:draft), "draft"], [t(:published), "published"]],
                          default_state )
    end

The view code is clean now, we can just call the helper method to load all needed options.
