---
layout: post
title: Simplify render in controllers
author: Richard Huang (flyerhzm@gmail.com)
description: Like the simplify render in views, from rails 2.3, we can also simplify render in controllers.
tags:
- controller
likes:
- flyerhzm (flyerhzm@gmail.com)
- David Westerink (davidakachaos@gmail.com)
- jrichardlai (jrichardlai@gmail.com)
- ChuckJHardy (chuckjhardy@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- Locke23rus (locke23rus@gmail.com)
- logankoester (logan@logankoester.com)
- kugaevsky (nick@kugaevsky.ru)
- bugmenot (fhugfizn@sharklasers.com)
dislikes:
- 
---
Like simplify render in views, from rails 2.3, we can also simplify render in controllers. Here I will show you the contrast.

Rendering an Action's View
---------------------------------------

**Before**

    render :action => :edit
    render :action => 'edit'

**After**

    render :edit
    render 'edit'

Rendering an Action’s Template from Another Controller
---------------------------------------------------------------------------------

**Before**

    render :template => 'books/edit'

**After**

    render 'books/edit'

Rendering an Arbitrary File
--------------------------------------

**Before**

    render :file => '/path/to/rails/app/views/books/edit'

**After**

    render '/path/to/rails/app/views/books/edit'

