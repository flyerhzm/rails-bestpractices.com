---
layout: post
title: Use render :collection Rails 3 when possible
author: Helmut Juskewycz (hjuskewycz@hemju.com)
description: 
tags:
- view
- render
- collection
likes:
- eric (eric@pixelwareinc.com)
- JamesCotterill (mail@jamescotterill.co.uk)
- David Westerink (davidakachaos@gmail.com)
- Locke23rus (locke23rus@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
dislikes:
- 
---
In Rails 3, render :collection is much faster than looping over a collection and calling render :partial manually.
Some initial benchmarking showed up to 3 times faster rendering when render :collection was used.

Thanks to Yehuda for this protip (sended via Twitter)
