---
layout: post
title: use after_commit
author: Richard Huang (flyerhzm@gmail.com)
description: Most developers use AR callbacks after_create/after_update/after_destroy to generate background job, expire cache, etc., but they don't realize these callbacks are still wrapped in database transaction, they probably got unexpected errors on production servers. 
tags:
- model
likes:
- flyerhzm (flyerhzm@gmail.com)
- samir (samirbraga@gmail.com)
- matthewcford (matt@bitzesty.com)
- matthewcford (matt@bitzesty.com)
- saulius (saulius@ninja.lt)
- saulius (saulius@ninja.lt)
- astrauka (astrauka@gmail.com)
- cbarton (c.chris.b@gmail.com)
- tsyren.ochirov (nsu1team@gmail.com)
- ilstar (xingqinglzq@gmail.com)
- li.daobing (lidaobing@gmail.com)
- 29decibel (mike.d.1984@gmail.com)
- jaredobson (jared.dobson@live.com)
- bitpimpin (m@rkcoates.com)
- YannLugrin (yann.lugrin@sans-savoir.net)
- PikachuEXE (pikachuexe@gmail.com)
- viniciusgati (viniciusgati@gmail.com)
- kushal_mistry (kushal_mistry@live.in)
- hariharanji (hharanh.g@gmail.com)
- ali.bugdayci.50 (bugdayci@gmail.com)
dislikes:
- 
---
A relational database, like mysql, provides transactions to wrap several operations in one unit, make them all pass or all fail. All isolation levels except READ UNCOMMITTED don't allow read data changes until they are committed in other transaction. If you don't realize it, you probably introduce some unexpected errors.

## Before

It's common to generate a background job to send emails, tweets or post to facebook wall, like

    class Notification < ActiveRecord::Base
      after_create :asyns_send_notification

      def async_send_notification
        NotificationWorker.async_send_notification({:notification_id => id})
      end
    end

    class NotificationWorker < Workling::Base
      def send_notification(params)
        notification = Notification.find(params[:notification_id])
        user = notification.user
        # send notification to user's friends by email
      end
    end

It looks fine, every time it creates a notification, generates an asynchronous worker, assigns notification_id to the worker, in the worker it finds the notification by id, then sends notification by email.

You won't see any issue in development, as local db can commit fast. But in production server, db traffic might be huge, worker probably finish faster than transaction commit. e.g.

<table>
  <thead>
    <tr>
      <th>main process</th>
      <th>worker process</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>BEGIN</td>
      <td></td>
    </tr>
    <tr>
      <td>INSERT INTO notifications(message, user_id) values('notification message', 1)</td>
      <td></td>
    </tr>
    <tr>
      <td># return id 10 for newly-created notification</td>
      <td></td>
    </tr>
    <tr>
      <td></td>
      <td>SELECT * FROM notifications WHERE id = 10</td>
    </tr>
    <tr>
      <td>COMMIT</td>
      <td></td>
    </tr>
  </tbody>
</table>

In this case, the worker process query the newly-created notification before main process commits the transaction, it will raise NotFoundError, because transaction in worker process can't read uncommitted notification from transaction in main process.

Refactor
--------

So we should tell activerecord to generate notification worker after notification insertion transaction committed.

    class Notification < ActiveRecord::Base
      after_commit :asyns_send_notification, :on => :create

      def async_send_notification
        NotificationWorker.async_send_notification({:notification_id => id})
      end
    end

Now the transactions order becomes

<table border="1">
  <thead>
    <tr>
      <th>main process</th>
      <th>worker process</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>BEGIN</td>
      <td></td>
    </tr>
    <tr>
      <td>INSERT INTO notifications(message, user_id) values('notification message', 1)</td>
      <td></td>
    </tr>
    <tr>
      <td># return id 10 for newly-created notification</td>
      <td></td>
    </tr>
    <tr>
      <td>COMMIT</td>
      <td></td>
    </tr>
    <tr>
      <td></td>
      <td>SELECT * FROM notifications WHERE id = 10</td>
    </tr>
  </tbody>
</table>

Worker process won't receive NotFoundErrors any more.

For those callbacks that no need to execute in one transaction, you should always use after_commit to avoid unexpected errors.

after_commit is introduced from rails 3, if you use rails 2, please check out [after_commit][1] gem instead.


  [1]: https://rubygems.org/gems/after_commit
