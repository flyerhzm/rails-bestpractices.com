---
layout: post
title: Use asset_host for production server
author: Richard Huang (flyerhzm@gmail.com)
description: Use asset host for cookie-free domains for components, that make your components load faster.
tags:
- performance
- assets
likes:
- flyerhzm (flyerhzm@gmail.com)
- mdorfin (dorofienko@gmail.com)
- eric (eric@pixelwareinc.com)
- questioner (questioner@gmail.com)
- Codeblogger (codeblogger@gmail.com)
- madeofcode (markdodwell@gmail.com)
- yorzi (wangyaodi@gmail.com)
- Nikos D. ()
- kylemathews (kylemathews@gmail.com)
- des (Ijon57@gmail.com)
- matthewcford (matt@bitzesty.com)
- Locke23rus (locke23rus@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- 29decibel (mike.d.1984@gmail.com)
- lisovskyvlad (lisovskyvlad@gmail.com)
- valner.medeiros (valner.medeiros@gmail.com)
- PsiCat (ogealter@gmail.com)
dislikes:
- 
---
If you set your application and assets (image, stylesheet and javascript) on the same domain, the browser and server will pass cookies for each asset request, which is not necessary and waste your bandwidth.

According to one of the Yahoo's best practices for speeding up your web site, use cookie-free domains for components, we should define different domain for application and assets, that make your assets load faster.

It's easy in rails, just enable the asset_host on production environment configuration file.

    config.action_controller.asset_host = "http://assets.rails-bestpractices.com"

Then you should create an asset server configuration on your web server, I give you the example of nginx here.

    server {
        listen 80;
        server_name assets.rails-bestpractices.com;
        root /var/www/rails-bestpractices.com/production/current/public;
    }

So after you restart your server and redeploy your application, you will see all the images, stylesheets and javascripts are loaded from assets.rails-bestpractices.com without cookies.

This is what the rails-bestpractices.com website did.
