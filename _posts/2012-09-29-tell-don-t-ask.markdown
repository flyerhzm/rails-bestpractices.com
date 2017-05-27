---
layout: post
title: Tell, don't ask
author: Zamith
description: Methods should focus on what you want done and not how you want it.
tags:
- model
- refactor
---
## Before

The birth_year method is asking the user for her birthday and then getting the year, and if doesn't have one respond accordingly.

    def birth_year(user)
      if user.birthday
        user.birthday.year
      else
        'No birthday year on file'
      end
    end

## Refactor

It should be telling the user to provide a birthday year and expect a coherent response if it has one or not.

    def birth_year(user)
      user.birthday.year
    end

    class User
      def birthday
        @birthday || NullBirthday.new
      end
    end

    class NullBirthday
      def year
        'No birthday year on file'
      end
    end
