---
layout: post
title: Replace instance variable with local variable
author: Wen-Tien Chang (ihower@gmail.com)
description: In partial view, we can use the instance variable directly, but it may be confused and make it hard to reuse anywhere, because we don't know exactly which instance variable can be used, so use the local variable in partial with explicitly assignment.
tags:
- view
likes:
- ihower (ihower@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- ixandidu (ixandidu@gmail.com)
- sprysoft (david@spry-soft.com)
- batasrki (spejic@gmail.com)
- fireflyman (yangxiwenhuai@gmail.com)
- slevin (tsyren.hey@gmail.com)
- jaimeiniesta (jaimeiniesta@gmail.com)
- akoc (aivars.akots@gmail.com)
- José Galisteo Ruiz ()
- kylemathews (kylemathews@gmail.com)
- leobessa (leobessa@gmail.com)
- regedor (miguelregedor@gmail.com)
- indrekj (indrek@urgas.eu)
- juancolacelli (juancolacelli@gmail.com)
- des (Ijon57@gmail.com)
- emmanuel delgado ()
- anga (andres.b.dev@gmail.com)
- jdprc06 (pricejosephd@gmail.com)
- nathanvda (nathan@dixis.com)
- tarasevich (tarasevich.a@gmail.com)
- dmdv (dimos-d@yandex.ru)
- jasperkennis (jasper@fontanel.nl)
- li.daobing (lidaobing@gmail.com)
- leolukin (leolukin@gmail.com)
- bugmenot (fhugfizn@sharklasers.com)
- syriusz.p@gmail.com (syriusz.p@gmail.com)
dislikes:
- eric (eric@pixelwareinc.com)
- cbetta (cbetta@gmail.com)
---
A partial is a reusable view template, it allow you to modularize the components which make up a particular page into logical, cohesive pieces. When required data is not passed into a partial, it is often difficult to reuse or change later.

By passing the required data in as locals you create self-documenting requirements for each view
partial. It also helps to see where else it is rendered and what locals are required.

Bad Smell
---------

    class PostsController < ApplicationController
      def show
        @post = Post.find(params[:id])
      end
    end
    
    <%= render :partial => "sidebar" %>

In this example, the partial sidebar can use the instance variable @post, but we can't know what's the instance variable @post without checking the controller codes. Let's use the local variable instead.

Refactor
--------

    <%= render :partial => "sidebar", :locals => { :post => @post } %>

or

    <%= render "sidebar", :post => @post %>

Now we can use the local variable post in partial, it is much simpler.

