---
layout: post
title: Not use time_ago_in_words
author: Richard Huang
description: It's very common for a rails developer to use time_ago_in_words to display time like "5 minutes ago", but it's too expensive to calculate the time in server side, you should utilize client cpu to calculate the time ago.
tags:
- helper
- javascript
---
Rails provides a helper method time_ago_in_words to display the distance between one time and now, like "5 minute ago", it's very useful.

Before
------

    <%= times_ago_in_words(comment.created_at) %>

It looks fine, but we have some room to improve.

 1. Your servers have to calculate the time ago for each request, it wastes the cpu capability on server side, why not move the calculation to client side.
 2. If we calculate the time ago on server side, it gets difficult to cache the page. e.g. after you create a comment, the time ago of the comment shows "5 seconds ago", if you cache the page, the time ago still show "5 second ago" after 3 minute (depends on your cache strategy).

Refactor
--------

The solution is to use browser script like javascript. On server side, what you need is to pass the created or updated time instead of calculated time ago, then the javascript will calculate the time ago on client side.

    <abbr class="timeago" title="<%= comment.created_at.getutc.iso8601 %>">
      <%= comment.created_at.to_s %>
    </abbr>

here is a javascript solution based on jquery [http://timeago.yarp.com/][1], of course, you can use other time ago js library.

    $("abbr.timeago").timeago();

Now, you save the server cpu capability and make your page easier to cache.


  [1]: http://timeago.yarp.com/
