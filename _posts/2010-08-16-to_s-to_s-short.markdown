---
layout: post
title: to_s/to_s(:short)
author: Yincan (shengyincan@gmail.com)
description: override the to_s to make the method sensible  instead of "display_name", "format_name"..
tags:
- naming
- convention
likes:
- eric (eric@pixelwareinc.com)
- flyerhzm (flyerhzm@gmail.com)
- David Westerink (davidakachaos@gmail.com)
- DefV (rbp@defv.be)
- Derek Croft ()
- kylemathews (kylemathews@gmail.com)
- matthewcford (matt@bitzesty.com)
dislikes:
- Guillermo (guillermo@cientifico.net)
- Alfuken ()
- juancolacelli (juancolacelli@gmail.com)
- Locke23rus (locke23rus@gmail.com)
- tarasevich (tarasevich.a@gmail.com)
---
Change from 

    def display_name
        "#{first_name} #{last_name}"...
    end

to

    def to_s
         "#{first_name} #{last_name}"...
    end
