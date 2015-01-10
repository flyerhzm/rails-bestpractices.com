---
layout: post
title: Clever enums in rails
author:  (kuba@codequest.com)
description: After many years of rails developing I have finally found satisfying solution to implement enums in rails.
tags:
- rails
- enums
- array
- typo
likes:
- pftg (paul.nikitochkin@gmail.com)
- marocchino (marocchino@gmail.com)
- codequest (kuba@codequest.com)
- warkocz (warkocz@gmail.com)
- andy318 (andy318@hotmail.com)
- rainchen (hirainchen@gmail.com)
- zhuravel (zhuravel@lavabit.com)
- PriteshRocks (prit.jain86@gmail.com)
- bugmenot (fhugfizn@sharklasers.com)
- PatrickSimply (yinghau76@gmail.com)
- Wirwing (irving.cf@gmail.com)
- brytiuk (brytiuk@ukr.net)
- zx1986 (zx1986@gmail.com)
dislikes:
- 
---
## Before

    class Photo < ActiveRecord::Base 
    	STATUSES = ['queued', 'new', 'changed', 'removed', 'ready']
    
        def change_status
    	    self.status = 'changed'
        end
    end

In this example we have a list of statuses stored in db as strings. Changing status requires developer to find STATUSES Array and manually type proper value. Typing string status can lead to generate hard to find bugs if developer made a typo.

    class Photo < ActiveRecord::Base 
        STATUSES = {queued: 'queued', new: 'new', changed: 'changed', removed: 'removed', ready: 'ready'}

        validates :status, inclusion: {in: STATUSES.values}

        def change_status
            self.status = STATUSES[:new]
        end
    end

In this example developer can not make a typo, but he still needs to look for STATUSES array to find out what values are valid. Validations require Hash#values method to work, as same as, for example, select_tag on views.

## Refactor

    class Photo < ActiveRecord::Base 
        STATUSES = [STATUS_QUEUED = 'queued', STATUS_NEW = 'new', STATUS_CHANGED = 'changed', STATUS_REMOVED = 'removed', STATUS_READY = 'ready']

        validates :status, inclusion: {in: STATUSES}

        def change_status
            self.status = Photo::STATUS_QUEUED
        end
    end

Declaring constants referred to values of STATUS array, inside array, allows developer to keep validations clear, protects him against typos and, in most IDEs, autocompletes status values even outside of the class.



Jakub Niewczas
Software Engineer
http://codequest.com
