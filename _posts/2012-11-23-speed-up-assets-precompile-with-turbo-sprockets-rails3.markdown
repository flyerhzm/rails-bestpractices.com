---
layout: post
title: speed up assets precompile with turbo-sprockets-rails3
author: Richard Huang (flyerhzm@gmail.com)
description: Rails is integrated with sprockets from 3.1, which gives you the power to pre-process, compress and minify your assets. It's awesome, but it slows down deployment a lot. 
tags:
- assets
- deployment
likes:
- flyerhzm (flyerhzm@gmail.com)
- li.daobing (lidaobing@gmail.com)
- kadoppe (kadoppe@me.com)
- therealkris (kristopher.triplett@gmail.com)
- saida (saida.temirkhodjaeva@gmail.com)
- Mike (mike@odania-it.de)
- alauper (adamlauper@gmail.com)
- 风之暗殇典 (gaodu328110@163.com)
dislikes:
- 
---
I love the assets pipeline which is introduced by rails 3.1, it processes, compresses and minifies javascripts, stylesheets and images automatically, that makes my websites display faster to users. It's pretty simple, you can just add one line to your Capfile

    load 'deploy/assets'

then all assets precompiling stuff will be done during deployment.

But assets precompile is significantly slow, it consumes a lot of cpu resources, you have to wait much longer time for capistrano deployment. But sometimes I just added a hotfix for backend code or fix a typo on html, it still precompile all assets no matter if any asset files are changed. 

There are several solutions:

1\. override the default deploy:assets:precomple task by yourself, compare the new asset files with old asset files, if there are no changes, skip the asset:precomple task. Here is an example: <https://gist.github.com/3072362>

2\. thank @ndbroadbent for releasing a gem [turbo-sprockets-rails3][0], it's smarter and only recompiling changed assets. It's also simpler, what you need to do is add turbo-sprockets-rails3 gem to your Gemfile, then enjoy speeding up deployment.

[0]: https://github.com/ndbroadbent/turbo-sprockets-rails3
