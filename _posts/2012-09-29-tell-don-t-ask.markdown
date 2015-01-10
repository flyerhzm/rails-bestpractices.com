---
layout: post
title: Tell, don't ask
author: Zamith (zamith.28@gmail.com)
description: Methods should focus on what you want done and not how you want it.
tags:
- model
- refactor
likes:
- zigomir (zigomir@gmail.com)
- rmdmachado (rmdmachado@gmail.com)
- andrefs (andrefs@cpan.org)
- 5thWall (5thwall@gmail.com)
- jonathonjones (jonathonjonesphilosophy@gmail.com)
- millisami (millisami@gmail.com)
- antoniolorusso (antonio.lorusso@gmail.com)
- RichGuk (richguk@gmail.com)
- smodiz (sharonmodiz@yahoo.com)
dislikes:
- DanBlack (klobor@yandex.ru)
- rwz (rwz@duckroll.ru)
- Petr Blaho ()
- Lukom (lllukom@gmail.com)
- bitpimpin (m@rkcoates.com)
- end_guy (dchapman1988@gmail.com)
- Carlos Brando (eduardobrando@gmail.com)
- Alfuken ()
- zmajstor (zmajstor@me.com)
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
