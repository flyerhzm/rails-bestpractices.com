---
layout: post
title: Active Record Query Interface Optimization
author: Angelo Capilleri
description: Use  select  with  has_many and belongs_to on Active Record Associations
tags:
- refactor
- model
- performance
---
Using the `select` parameter in Active Record association, you can speed up your application about 50% and more.
The following example is only focused on the optimization of the association using select, so there are further optimizations for the following examples.

**Given two models:**

    class Patient < ActiveRecord::Base
      belongs_to :physician
    end
    class Physician < ActiveRecord::Base
      has_many :patients
    end

**After refactoring:**

    class Patient < ActiveRecord::Base
      belongs_to :physician, :select => 'id,name, surname'
    end

    class Physician < ActiveRecord::Base
      has_many :patients, :select => 'id,name, physician_id'
    end

I used a Patient table with 2000 records and Physician table with 4000 records, for testing. Gived the following query:

 @physicians = Physician.includes(:patients).all

Generated Sql is:

**Before refactoring:**

    Physician Load (33.9ms)  SELECT `physicians`.* FROM `physicians`
    Patient Load (66.5ms)  SELECT `patients`.* FROM `patients` WHERE `patients`.`physician_id` IN (1, 2, 3,...)

**After refactoring:**

    Physician Load (31.8ms)  SELECT `physicians`.* FROM `physicians`
    Patient Load (22.3ms)  SELECT name,physician_id,id FROM `patients` WHERE `patients`.`physician_id` IN (1, 2, 3,...)

Obviously you can refactor the query association with belongs_to:

    @patients = Patient.includes(:physician).all

**Before refactoring:**

    SELECT `patients`.* FROM `patients`
    Physician Load (32.5ms)  SELECT `physicians`.* FROM `physicians` WHERE `physicians`.`id` IN (1, 1799, 1562, 611, 1287...)

**After refactoring:**

    SELECT `patients`.* FROM `patients`
    Physician Load (10.1ms)   SELECT id,name,surname FROM `physicians` WHERE `physicians`.`id` IN (1, 1799, 1562, 611, 1287...)

