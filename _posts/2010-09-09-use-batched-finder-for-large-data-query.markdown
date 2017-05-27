---
layout: post
title: Use batched finder for large data query
author: Richard Huang
description: If you want to do a large data query such as finding all the 10,000,000 users to send email to them, you should use batched finder to avoid eating too much memory.
tags:
- model
- performance
- task
---
Imagine you have a newsletter system which is very famous and has 10,000,000 users. Every Monday morning, the system will send emails to all of the users.

In General
----------

You may find all the users, then send emails to them one by one

    User.all.each do |user|
      NewsLetter.weekly_deliver(user)
    end

It may work, but do you know there are 10,000,000 users? This code snippet will find all of the users and create a ruby object for each user row in table. The server is unhappy due to too much memory is eaten by your newsletter application.

Improvement
-----------

From rails 2.3, find_each and find_in_batches are available for batched finder. We can use them to improve the performance of the newsletter application.

    User.find_each do |user|
      NewsLetter.weekly_deliver(user)
    end

Using find_each, the application only finds 1,000 users once, yield them, then handle the next 1,000 users, until the last 1,000 users. That means the application will only load 1,000 user objects into memory each time, the server is happy now.

1,000 is the default batch size, if you think it is small/big to you, you can use the :batch_size option to change it.

find_in_batches is similar to find_each except that it yields the array of objects

    User.find_in_batches(:batch_size => 5000) do |users|
      users.each { |user| NewsLetter.weekly_deliver(user) }
    end

This method is very useful for large data query, saving your memory and time.
