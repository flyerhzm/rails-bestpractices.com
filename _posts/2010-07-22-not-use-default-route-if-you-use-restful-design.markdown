---
layout: post
title: Not use default route if you use RESTful design
author: Wen-Tien Chang (ihower@gmail.com)
description: If you use RESTful design, you should NOT use default route. It will cause a security problem. I explain at http://ihower.tw/blog/archives/3265 too.
tags:
- rails2
- route
likes:
- ihower (ihower@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- iGEL (igel@igels.net)
- AndrÃ© Moreira ã‚ªã‚¿ã‚¯ ()
- madeofcode (markdodwell@gmail.com)
- นีโอเคน ()
- avsej (sergey.avseyev@gmail.com)
- regedor (miguelregedor@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
dislikes:
- 
---
Bad Smell
---------

    map.resources :posts, :member => { :push => :post }
    
    map.connect ':controller/:action/:id'
    map.connect ':controller/:action/:id.:format'

Why do not use the default route? In this example, you define the resources posts, that means user can only create a post by HTTP POST, update a post by PUT and destroy a post by DELETE. If this is what you expect, default route will be a security problem, because user can create, update or destroy a post by HTTP GET if you define the default route.

Refactor
--------

    map.resources :posts, :member => { :push => :post }
    
    #map.connect ':controller/:action/:id'
    #map.connect ':controller/:action/:id.:format'
    
    map.connect 'special/:action/:id', :controller => 'special'

Because default route is evil, just comment out or remove it (if you use RESTful)
