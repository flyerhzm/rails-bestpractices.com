---
layout: post
title: monitor your backend services
author: Richard Huang (flyerhzm@gmail.com)
description: We always have multiple processes for rails websites, if any of them crashed, your website failed, so it would be better to monitor all of the processes and automatically restart crashed processes.
tags:
- system administration
likes:
- flyerhzm (flyerhzm@gmail.com)
- Mike (mike@odania-it.de)
- rdasarminus (rdasarminus@gmail.com)
- brytiuk (brytiuk@ukr.net)
dislikes:
- 
---
I have maintained [rails-bestpractices.com](rails-bestpractices.com) website for several years, not only code, but also server administration. The website is running on [linode](http://www.linode.com/?r=aa5686444f1835b95ee23ee5321824f6bc75c550) with multiple processes:

 1. nginx - http reverse proxy server
 2. puma - ruby app server
 3. mysql - database server
 4. memcached - cache server
 5. sphinx - full text search server
 6. delayed_job - background job process

As you can see, it has multiple dependencies, if one of these processes stopped, the website is down or some features disabled. It's very common that your processes are terminated, like the host is power outage or cpu / memory usage is too high. So you need a tool that can monitor your processes and restart them automatically after crashed.

Generally you have 2 choices: [god](http://godrb.com/) and [monit](http://mmonit.com/), both of them work well. God is a ruby gem, monit is a more generic monitoring tool, they can monitor servers, processes, send notifications if resource usage is higher than you expected, they can restart your processes if crashed, they also provide terminal and web ui to check processes status.

Here is the god status

    $ god status
    conferences-box-server:
      conferences-box-server.1: up
      conferences-box-server.2: up

Monit status looks more powerful

    $ sudo monit status
    The Monit daemon 5.0.3 uptime: 2d 18h 15m 

    System 'app.railsbp.com'
      status                            running
      monitoring status                 monitored
      load average                      [0.00] [0.04] [0.05]
      cpu                               0.0%us 0.0%sy 0.0%wa
      memory usage                      499136 kB [48.5%]
      data collected                    Thu Mar 28 10:12:19 2013

    Process 'memcached'
      status                            running
      monitoring status                 monitored
      pid                               2246
      parent pid                        1
      uptime                            8d 18h 13m 
      children                          0
      memory kilobytes                  20628
      memory kilobytes total            20628
      memory percent                    2.0%
      memory percent total              2.0%
      cpu percent                       0.0%
      cpu percent total                 0.0%
      data collected                    Thu Mar 28 10:12:19 2013

After using them, I never worried if rails-bestpractices.com is down, even after a server restart. :-)
