---
layout: post
title: use OpenStruct when advance search
author: Alvin Ye (alvin.ye.cn@gmail.com)
description: use OpenStruct when advance search
tags:
- search
- view
likes:
- mdorfin (dorofienko@gmail.com)
- Just Lest ()
- eric (eric@pixelwareinc.com)
- grobie (tobi@gronom.de)
- Dmitry Nesteruk ()
- alvin2ye (alvin.ye.cn@gmail.com)
- electrum (david@acz.org)
- des (Ijon57@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- CITguy (rhino.citguy@gmail.com)
- arpadlukacs (arpad.lukacs@gmail.com)
- xiaoronglv (xiaoronglv@hotmail.com)
dislikes:
- codeofficer (spam@codeofficer.com)
---
Before 

# in view 

    <% form_for_tag blabal do |f| %> 
      <%= f.text_field_tag :quick, params[:search][:quick] %> 
     <%= select_tag("country", options_for_select([["unassigned" , "0" ]] +
                      Country.to_dropdown, region.country_id),
                      {:name => "search[country]"} ) %>
      <%= f.submit "Search" %> 
    <% end %>

After

# in controller 

    require 'ostruct' 
    
    def index 
      @search = OpenStruct.new(params[:search]) 
    end 

# in view 

    <% form_for :search, :url => {:action => "index"}, :html => {:method => :get} do |f| %> 
      <%= f.text_field :quick %> 
      <%= f.select :quick, Country.to_dropdown %> 
      <%= f.submit "Search" %> 
    <% end %>
