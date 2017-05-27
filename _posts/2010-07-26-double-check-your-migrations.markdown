---
layout: post
title: Double-check your migrations
author: Jaime Iniesta
description: When you generate a new migration, try it forwards and backwards to ensure it has no errors
tags:
- migration
---
Many developers only check their migrations work on the forward step (rake db:migrate) but not so often on the backwards step (rake db:rollback).

When I create a new migration, I like to do a little sanity check to be sure it works on both ways and it's free of typos or other errors. I just mean:

    rake db:migrate
    rake db:rollback
    rake db:migrate

Or better and simpler:

    rake db:migrate
    rake db:migrate:redo
