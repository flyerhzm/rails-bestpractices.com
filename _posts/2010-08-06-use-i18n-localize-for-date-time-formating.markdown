---
layout: post
title: Use I18n.localize for date/time formating
author: Ng Tze Yang (ngty77@gmail.com)
description: For reliable formatting of a date/time string in the desired language, use I18n.localise, Time#strftime can cause u unnecessary headache.
tags:
- I18n
likes:
- flyerhzm (flyerhzm@gmail.com)
- David Westerink (davidakachaos@gmail.com)
- indrekj (indrek@urgas.eu)
- Raecoo (raecoo@gmail.com)
- matthewcford (matt@bitzesty.com)
- juancolacelli (juancolacelli@gmail.com)
- Locke23rus (locke23rus@gmail.com)
- xaphtrick (mzcakmak@gmail.com)
dislikes:
- 
---
On different machines, Time#strftime can yield different results, and there is no reliable way to ensure u get the string with the desired language, even after setting the environment variable $LANG, and even recompiling ruby under the desired locale setting. Use I18n.localize instead:

    I18n.localize(Time.now) # using :default format
    I18n.localize(Time.now, :format => :short) # using short format

    I18n.localize(Date.today) # using :default format
    I18n.localize(Date.today, :format => :short) # using short format

In view layer, u can replace the verbose I18n.localize(...) with just shorthand l(...).
    
All u need is to have the appropriate yml data file under config/locales, the resources at http://github.com/svenfuchs/rails-i18n/tree/master/rails/locale/ provides a good starting point.

    
