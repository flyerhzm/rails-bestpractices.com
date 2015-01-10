---
layout: post
title: Put scripts at the bottom
author: Richard Huang (flyerhzm@gmail.com)
description: Do you experience that your website renders slow due to loading a lot of javascripts, especially loading some third-party javascripts? Move script tags to the bottom of body can speed up the render of your website.
tags:
- view
- performance
- assets
- javascript
likes:
- flyerhzm (flyerhzm@gmail.com)
- gdurelle (gregory.durelle@gmail.com)
- eric (eric@pixelwareinc.com)
- Abdulaziz Al-Shetwi ()
- tjsingleton (tjsingleton@vantagestreet.com)
- Artur Roszczyk ()
- mattiasjes (mpj@mpj.me)
- juancolacelli (juancolacelli@gmail.com)
- PsiCat (ogealter@gmail.com)
- bugmenot (fhugfizn@sharklasers.com)
dislikes:
- alauper (adamlauper@gmail.com)
---
Do you have experience that you website renders slow due to loading a lot of javascripts? According to yahoo's website best practices, we should put the scripts at the bottom.

By default rails layout, our application loads javascripts before rendering pages.

    <html>
      <head>
        ......
        <%= javascript_include_tag 'jquery', 'rails', 'jquery.autocomplete', 'prettify', 'wmd', 'application' %>
      </head>
      ......
    </html>

To speed up the pages render, we can juts move the javascripts to the bottom of body.

    <html>
      <head>
        ......
      </head>
      <body>
        ......
        <%= javascript_include_tag 'jquery', 'rails', 'jquery.autocomplete', 'prettify', 'wmd', 'application' %>
      </body>
    </html>

Now the web pages will be displayed to users first, then load javascripts, the pages render much faster. But it depends on your application, not all the javascripts can be put at the bottom, be careful.

Be attention you should always put the third party javascript at the bottom, why? Because third-party javascripts may be slow to load. More important, you website will be "broken" (very very very slow to render) due to loading javascripts from a remote site which goes down. For example, our website has a tweet button, the widget code copied from twitter website is as follows

    <a href="http://twitter.com/share" class="twitter-share-button" 
      data-text="Rails Best Pracitces" data-url="http://rails-bestpractices.com" 
      data-count="horizontal" data-via="railsbp">Tweet</a>
    <script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>

At first, we put the widget code at the top of body element, but we found it always slow down the pages render and sometimes "break" the website. So we decided to put the javascript at the bottom.

    <body>
      <a href="http://twitter.com/share" class="twitter-share-button" 
        data-text="Rails Best Pracitces" data-url="http://rails-bestpractices.com" 
        data-count="horizontal" data-via="railsbp">Tweet</a>
      ......
      <script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
    </body>

So the twitter widget javascript never slows down and breaks the web pages render. We do the same thing for addthis javascript.
