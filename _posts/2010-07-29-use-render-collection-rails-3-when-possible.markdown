---
layout: post
title: Use render :collection Rails when possible
author: Helmut Juskewycz
description:
tags:
- view
- render
- collection
---
In Rails 3, render :collection is much faster than looping over a collection and calling render :partial manually.
Some initial benchmarking showed up to 3 times faster rendering when render :collection was used.

Thanks to Yehuda for this protip (sended via Twitter)
