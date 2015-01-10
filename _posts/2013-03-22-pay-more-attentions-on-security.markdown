---
layout: post
title: Pay more attentions on security
author: Richard Huang (flyerhzm@gmail.com)
description: Recently we saw rails exposed some security issues, github was attacked, rubygems.org was crashed, they all remind us we must pay more attentions on our rails projects.
tags:
- security
likes:
- flyerhzm (flyerhzm@gmail.com)
- 风之暗殇典 (gaodu328110@163.com)
dislikes:
- 
---
Rails is still one of the best frameworks to build websites, it solved a lot of security issues by default, like SQL injection and Cross-Site Scripting. Thanks for the rails community, people report security issues, rails team will fix them and release patches asap, all we should do is to keep our rails projects up to date.

Although rails provides a lot of ways to avoid security issues, you need to keep in mind that you must not trust anything that user input, it can contain a script, a sql or anything that may hurt your system. Check out [rails security guide page](http://guides.rubyonrails.org/security.html) for more

I'd like to introduce a tool that can help you find out security issues in your rails repositories, it's [brakeman](https://github.com/presidentbeef/brakeman). It will statically analyze your rails repo code, then tell you the potential security issues, it's awesome. I also created a service based on it, [rails-brakeman.com](http://rails-bestpractices.com), it will analyze source code after you push to github and then send a email notification.

I'm glad to hear more methods and tools you used to make your rails websites secure.
