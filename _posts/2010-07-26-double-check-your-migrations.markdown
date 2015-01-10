---
layout: post
title: Double-check your migrations
author: Jaime Iniesta (jaimeiniesta@gmail.com)
description: When you generate a new migration, try it forwards and backwards to ensure it has no errors
tags:
- migration
likes:
- eric (eric@pixelwareinc.com)
- amaia (amaia@amaiac.net)
- Arnis Lapsa (arnis.lapsa@gmail.com)
- joshcrews (crews.josh@gmail.com)
- mdorfin (dorofienko@gmail.com)
- danroux (daniel.roux@gmail.com)
- nbrew (nhyde@bigdrift.com)
- yincan (shengyincan@gmail.com)
- jaimeiniesta (jaimeiniesta@gmail.com)
- Guillermo (guillermo@cientifico.net)
- Andrew Nesbitt ()
- smitjel (autiger02@gmail.com)
- Abdulaziz Al-Shetwi ()
- madeofcode (markdodwell@gmail.com)
- madeofcode (markdodwell@gmail.com)
- tjsingleton (tjsingleton@vantagestreet.com)
- poshboytl (poshboytl@gmail.com)
- timurv (me@timurv.ru)
- José Galisteo Ruiz ()
- abelmartin (abel.martin@gmail.com)
- ecleel (ecleeld@gmail.com)
- zanst (me@zan.st)
- juancolacelli (juancolacelli@gmail.com)
- ivobenedito (ivobenedito@gmail.com)
- SingleShot (mike.whittemore@gmail.com)
- matthewcford (matt@bitzesty.com)
- frp (franchukrom@gmail.com)
- sadfuzzy (sadfuzzy@yandex.ru)
- tarasevich (tarasevich.a@gmail.com)
- tadejm (tadej.murovec@gmail.com)
- leolukin (leolukin@gmail.com)
- ck3g (kalastiuz@gmail.com)
- JamesChevalier (jchevalier@gmail.com)
- davetoxa (davetoxa@gmail.com)
- ju (julian.popov@gmail.com)
- freemanoid321 (freemanoid321@gmail.com)
- freemanoid321 (freemanoid321@gmail.com)
- ahmad.alkheat.5 (wisamfaithful@gmail.com)
dislikes:
-
---
Many developers only check their migrations work on the forward step (rake db:migrate) but not so often on the backwards step (rake db:rollback).

When I create a new migration, I like to do a little sanity check to be sure it works on both ways and it's free of typos or other errors. I just mean:

    rake db:migrate
    rake db:rollback
    rake db:migrate

Or better and simpler:

    rake db:migrate
    rake db:migrate:redo




