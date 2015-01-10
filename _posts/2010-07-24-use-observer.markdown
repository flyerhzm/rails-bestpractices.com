---
layout: post
title: Use Observer
author: Wen-Tien Chang (ihower@gmail.com)
description: Observer serves as a connection point between models and some other subsystem whose functionality is used by some of other classes, such as email notification. It is loose coupling in contract with model callback.
tags:
- model
- observer
likes:
- ihower (ihower@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- ixandidu (ixandidu@gmail.com)
- kirkvq (kirkvq@gmail.com)
- mikhailov (mikhailov.anatoly@gmail.com)
- eric (eric@pixelwareinc.com)
- cash (ashley.c.woodard@gmail.com)
- tjsingleton (tjsingleton@vantagestreet.com)
- jayliud (jayliud@gmail.com)
- Derek Croft ()
- heironimus (kyle@heironimus.com)
- sbwdev (sbw.dev@gmail.com)
- grigio ()
- grigio ()
- marsbomber (jimli@elinkmedia.net.au)
- ecleel (ecleeld@gmail.com)
- eMxyzptlk (wael.nasreddine@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- gri0n (lejazzeux@gmail.com)
- ultrayoshi (david@imesmes.com)
- Julescopeland (jules@julescopeland.com)
- lukec (luke@talesa.net)
- arunkumar339 (arunkumar339@gmail.com)
- Deradon (deradon87@gmail.com)
- lguan77 (leon.guan@qq.com)
- ketzusaka (ketzu@me.com)
- frp (franchukrom@gmail.com)
- DataCatalyst (jamie@salesmaster.co.uk)
- dmdv (dimos-d@yandex.ru)
- tadejm (tadej.murovec@gmail.com)
- dgilperez (dgilperez@gmail.com)
- CITguy (rhino.citguy@gmail.com)
- danpolites (dpolites@gmail.com)
- guipereira (guipereira07@gmail.com)
- leolukin (leolukin@gmail.com)
- dvl8684 (dvl8684@gmail.com)
- bugmenot (fhugfizn@sharklasers.com)
dislikes:
- austinthecoder (austinthecoder@gmail.com)
- indrekj (indrek@urgas.eu)
- ju (julian.popov@gmail.com)
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
