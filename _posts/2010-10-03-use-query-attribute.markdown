---
layout: post
title: Use query attribute
author: Richard Huang (flyerhzm@gmail.com)
description: Do you always check if ActiveRecord's attributes exist or not by nil?, blank? or present? ? Don't do that again, rails provides a cleaner way by query attribute
tags:
- model
likes:
- flyerhzm (flyerhzm@gmail.com)
- mironov (ant.mironov@gmail.com)
- David Westerink (davidakachaos@gmail.com)
- นีโอเคน ()
- Shaliko (shaliko@ezid.ru)
- pake007 (pake007@gmail.com)
- Dmitry Nesteruk ()
- Hitesh Manchanda ()
- nice64 (niclas.vester@gmail.com)
- akoc (aivars.akots@gmail.com)
- José Galisteo Ruiz ()
- regedor (miguelregedor@gmail.com)
- iceydee (mionilsson@gmail.com)
- toyflish (mail@kairautenberg.de)
- y_310 (y310.1984@gmail.com)
- des (Ijon57@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- Locke23rus (locke23rus@gmail.com)
- gri0n (lejazzeux@gmail.com)
- _ismaelga (ismaelga@gmail.com)
- nathan.f77 (nathan.f77@gmail.com)
- alauper (adamlauper@gmail.com)
- leolukin (leolukin@gmail.com)
dislikes:
- CITguy (rhino.citguy@gmail.com)
---
Bad Smell
---------

    <% if @user.login.blank? %>
      <%= link_to 'login', new_session_path %>
    <% end %>
    
    <% if @user.login.present? %>
      <%= @user.login %>
    <% end %>

It's not bad, but rails provides a cleaner way, we should use query attributes to make codes simpler

Refactor
--------

    <% unless @user.login? %>
      <%= link_to 'login', new_session_path %>
    <% end %>
    
    <% if @user.login? %>
      <%= @user.login %>
    <% end %>

As you seen, the query attribute is almost the same as the present? method call on attribute, or the opposite of blank? method call. Each attribute of ActiveRecord's model has a query method, so you don't need to use the present? or blank? for ActiveRecord's attributes.
