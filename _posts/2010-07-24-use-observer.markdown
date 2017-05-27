---
layout: post
title: Use Observer
author: Wen-Tien Chang
description: Observer serves as a connection point between models and some other subsystem whose functionality is used by some of other classes, such as email notification. It is loose coupling in contract with model callback.
tags:
- model
- observer
---
Bad Smell
---------

    class Project < ActiveRecord::Base
      after_create :send_create_notifications

      private
        def send_create_notifications
          self.members.each do |member|
            ProjectMailer.deliver_notification(self, member)
          end
        end
    end

In this example, we use the model callback to send email notifications after creating a project. It would be better to use Observer because the email notification is a subsystem whose functionality is used by other classes.

Refactor
--------

    class Project < ActiveRecord::Base
      # nothing here
    end

    class NotificationObserver < ActiveRecord::Observer
      observe Project

      def after_create(project)
        project.members.each do |member|
          ProjectMailer.deliver_notice(project, member)
        end
      end
    end

Using the Observer, there is no necessary for Project to know about email notification, the NotificationObserver is responsible for sending emails after create a project, it may also sending emails for creating or updating an issue. It's much easier to maintain email notifications in one Observer than some email notification functions distributed over different models.

Updated: thanks @carlosantoniodasilva
