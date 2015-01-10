---
layout: post
title: Simplify render in views
author: Richard Huang (flyerhzm@gmail.com)
description: render is one of the often used view helpers, we can pass object, collection or local variables. From rails 2.3, more simplified syntax for render are provided.
tags:
- view
- partial
likes:
- jaimeiniesta (jaimeiniesta@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- dennis.j.bell (dennis.j.bell@gmail.com)
- John Griffin ()
- Marlon Gomes Lopes ()
- ecoologic (erikecoologic@gmail.com)
- y_310 (y310.1984@gmail.com)
- dimascyriaco (dimascyriaco@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- Locke23rus (locke23rus@gmail.com)
- raszi (railsbestpractices@spam.raszi.hu)
- CITguy (rhino.citguy@gmail.com)
- regedarek (darek.finster@gmail.com)
- milushov (rails-bestpractices@milushov.ru7)
- bugmenot (fhugfizn@sharklasers.com)
- scottweisman (scott@launchpadlab.com)
dislikes:
- americodls (americodls@gmail.com)
---
render is one of the often used view helpers, we use it to extract sub part view. We can pass object, collection or local variables to the partial views. From rails 2.3, more simplified syntax for render are provided that makes render helper cleaner. Here I will show you the contrast.

Render simple partial
================

**Before**

    <%= render :partial => 'sidebar' %>
    <%= render :partial => 'shared/sidebar' %>

**After**

    <%= render 'sidebar' %>
    <%= render 'shared/sidebar' %>

Render partial with object
===================

**Before**

    <%= render :partial => 'posts/post', :object => @post %>

**After**

    <%= render @post %>

Render partial with collection
=====================

**Before**

    <%= render :partial => 'post', :collection => @posts %>

**After**

    <%= render @posts %>

Render partial with local variables
========================

**Before**

    <%= render :partial => 'comments/comment', :locals => { :parent => post } %>

**After**

    <%= render 'comments/comment', :parent => post %>
