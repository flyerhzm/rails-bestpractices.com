---
layout: post
title: Use multipart/alternative as content_type of email
author: Richard Huang
description: Rails uses plain/text as the default content_type for sending email, you should change it to multipart/alternative that email clients can display html formatted email if they support and display plain text email if they don't support html format.
tags:
- mailer
---
Not all the email clients support html format well, we should make our sent emails support  both plain text and html format for different email clients.

text/plain
-------

By default Rails sending an email with **plain/text** content_type, for example

    # app/models/notifier.rb
    def send_email(email)
      subject       email.subject
      from          email.from
      recipients    email.recipients
      sent_on       Time.now
      body          :email => email
    end

    # app/views/notifier/send_email.html.erb
    Welcome to here: <%= link_to @email.url, @email.url %>

The sent email is a plain text email

    Date: Thu, 5 Aug 2010 16:38:07 +0800
    From: RailsBP <team@rails-bestpractices.com>
    To: flyerhzm@gmail.com
    Mime-Version: 1.0
    Content-Type: text/plain; charset=utf-8

    Welcome: <a href="http://rails-bestpractices.com">http://rails-bestpractices.com</a>

The link url is just displayed as a plain text because of the email content_type.

text/html
---------

If we want the email clients to display link url as html format, we should change the content_type to **text/html**.

    # app/models/notifier.rb
    def send_email(email)
      subject          email.subject
      from             email.from
      recipients       email.recipients
      sent_on          Time.now
      content_type     "text/html"
      body             :email => email
    end

Now the sent email is a html formatted email

    Date: Thu, 5 Aug 2010 17:32:27 +0800
    From: RailsBP <team@rails-bestpractices.com>
    To: flyerhzm@gmail.com
    Mime-Version: 1.0
    Content-Type: text/html; charset=utf-8

    Welcome: <a href="http://rails-bestpractices.com">http://rails-bestpractices.com</a>

Now the email client can display the link url correctly with html format.

multipart/alternative
---------------------

But we can't promise that all the email clients support the html format and some users will set the email client to display plain text email instead of html formatted email. How should we do?

We should use **multipart/alternative** as email content_type to support both text/plain and text/html emails.

    # app/models/notifier.rb
    def send_email(email)
      subject          email.subject
      from             email.from
      recipients       email.recipients
      sent_on          Time.now
      content_type     "multipart/alternative"

      part :content_type => "text/html",
        :body => render_message("send_email_html", :email => email)

      part "text/plain" do |p|
        p.body = render_message("send_email_plain", :email => email)
        p.transfer_encoding = "base64"
      end
    end

    # app/views/notifier/send_email_html.erb
    # app/views/notifier/send_email_plain.erb

As you see, we can set the email content_type to multipart/alternative, then define content_type text/html render the file app/views/notifier/send_email_html.erb and content_type text/plain render the file app/views/notifier/send_email_plain.erb. So the sent email is as follows

    Date: Thu, 5 Aug 2010 16:17:35 +0800
    From: RailsBP <team@rails-bestpractices.com>
    To: flyerhzm@gmail.com
    Mime-Version: 1.0
    Content-Type: multipart/alternative; boundary=mimepart_4c5a739f40ca1_967c1a0d6123


    --mimepart_4c5a739f40ca1_967c1a0d6123
    Content-Type: text/plain; charset=utf-8
    Content-Transfer-Encoding: Quoted-printable
    Content-Disposition: inline

    Welcome: <a href="http://rails-bestpractices.com">http://rails-bestpractices.com</a>

    --mimepart_4c5a739f40ca1_967c1a0d6123
    Content-Type: text/html; charset=utf-8
    Content-Transfer-Encoding: Quoted-printable
    Content-Disposition: inline

    Welcome: <a href="http://rails-bestpractices.com">http://rails-bestpractices.com</a>

    --mimepart_4c5a739f40ca1_967c1a0d6123--

As you see, the content_type of email is multipart/alternative now, and the body of email is divided into two parts, one is for text/plain, the other is for text/html. So email clients can decide which format of email to display.

Convention
----------

It's cool, but can the codes be simpler? Of course, there is a convention to simplifier the multipart/alternative content_type

    def send_email(email)
      subject          email.subject
      from             email.from
      recipients       email.recipients
      sent_on          Time.now
      body             :email => email
    end

    # app/views/notifier/send_email.text.plain.erb
    # app/views/notifier/send_email.text.html.erb

Please note the file extensions for notifier send_email method, one is **.text.plain.erb**, the other is **.text.html.erb**,
they are the email views for text/plain and text/html according to their names. ActionMailer will detect the file extension, if .text.plain and .text.html exist, the content_type of email will be set to multipart/alternative automatically.

**Updated**: in rails3, the mail view file names should be send_email.html.erb and send_email.text.erb
