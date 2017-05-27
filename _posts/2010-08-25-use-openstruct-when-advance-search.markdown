---
layout: post
title: use OpenStruct when advance search
author: Alvin Ye
description: use OpenStruct when advance search
tags:
- search
- view
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
