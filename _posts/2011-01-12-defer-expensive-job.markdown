---
layout: post
title: defer expensive job
author: Richard Huang (flyerhzm@gmail.com)
description: If you want to process something expensive as part of a web request, it will delay the response. If the job is not critical, it's wiser to move the expensive to a background queue and returns the response immediately.
tags:
- background job
likes:
- drivenator (drivenator@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- José Galisteo Ruiz ()
- gdurelle (gregory.durelle@gmail.com)
- David Westerink (davidakachaos@gmail.com)
- chucai (hexudong08@gmail.com)
- mtodd (chiology@gmail.com)
- marsbomber (jimli@elinkmedia.net.au)
- benjamintanweihao (firebladez86@gmail.com)
- matthewcford (matt@bitzesty.com)
- juancolacelli (juancolacelli@gmail.com)
- Locke23rus (locke23rus@gmail.com)
- anga (andres.b.dev@gmail.com)
- ketzusaka (ketzu@me.com)
dislikes:
- 
---
Synchronous Processing
------------------------------------

If you want to process something expensive as part of a web request, it will delay the response. The most common situations include sending emails to users, posting tweets, image and video processing, and etc. It is as know as synchronous processing. The processing is as follows

1. Client sends a request.
2. Server receives the request.
3. Server performs the request, including processing the expensive job, during the time, both the client and server are blocked and waiting.
4. Server sends response back to the client.
5. Client is free to continue processing.

The drawback of this synchronous processing is that client and server are blocked and waiting during the time the job is processing, although the server can handle multiple requests in common, the client still has to wait.

Asynchronous Processing
--------------------------------------

So if the job is not critical, it's wiser to move the expensive job into a background queue and returns the response immediately. It is as know as asynchronous processing. The process is as follows

1. Client sends a request. 
2. Server receives the request.
3. Server performs the request, queueing the expensive job to be processed by a background process.
4. Server sends a response immediately back to the waiting client.
5. Client is free to continue processing.

The advantage of using asynchronous processing is that the blocked and waiting time at both client and server sides are much less than before, as client and server don't need to wait the expensive job performing, it means that the client can get the response faster and the server can handle more requests per second. But there is a drawback that the client can't know the result of the expensive job real time. This is why I said "if the job is not critical".

There are many background job systems, such as delayed_job and resque, you can use any of them as you like. 

Besides the advantage of less blocked and waiting time, you can also get some additional benefits with the background job systems, such as assign priorities on jobs, retry on failure and etc.
