---
layout: post
title: Prevent SQL Injections by using the ? in queries
author:  (info@leolezner.de)
description: 
tags:
- sql injection
- query
likes:
- astjohn (astjohn@gmail.com)
- David Westerink (davidakachaos@gmail.com)
- Jakson Rochelly ()
- manic (maniclf@gmail.com)
- David Morton ()
- Artur Roszczyk ()
- gdurelle (gregory.durelle@gmail.com)
- 360andless (beanie@benle.de)
- juancolacelli (juancolacelli@gmail.com)
- Locke23rus (locke23rus@gmail.com)
- tomthorgal (thomas.vollath@gmail.com)
- matthewcford (matt@bitzesty.com)
dislikes:
- poshboytl (poshboytl@gmail.com)
---
Use the Question Mark to set the params of the query to prevent SQL Injections.

## Unsafe

    Product.where("alias = '#{params[:alias]}'")

## Safe

    Product.where("alias = ?", params[:alias])

ActiveRecord will sanitize the given params.

