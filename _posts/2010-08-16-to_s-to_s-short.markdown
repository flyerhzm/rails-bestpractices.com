---
layout: post
title: to_s/to_s(:short)
author: Yincan
description: override the to_s to make the method sensible  instead of "display_name", "format_name"..
tags:
- naming
- convention
---
Change from

    def display_name
        "#{first_name} #{last_name}"...
    end

to

    def to_s
         "#{first_name} #{last_name}"...
    end
