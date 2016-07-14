---
layout: post
title: Check the return value of "save", otherwise use "save!"
author: Richard Huang (flyerhzm@gmail.com)
description: The "save" method on ActiveRecord returns "false" and does nothing if the record is invalid. You should always check the return value, otherwise you may inadvertently not save the record. If you think the record can never be invalid, or don't want to check the return value, use "save!"
tags:
- active_record
likes:
- danpolites (dpolites@gmail.com)
- milushov (rails-bestpractices@milushov.ru7)
- alauper (adamlauper@gmail.com)
- freemanoid321 (freemanoid321@gmail.com)
dislikes:
- Nox (dimasavitski@gmail.com)
- kevin.sylvestre (kevin@ksylvest.com)
- adriano.bacha (abacha@gmail.com)
---
## Before

If you use "[save][1]" on an invalid record, it will not be saved:

    post = Posts.new do |p|
      p.title = "example"
      p.body = "An example"
    end
    post.save

This code may work at the moment, but it is fragile. If a later refactoring introduces a new required column to Posts, then the `save` call will silently start failing.

## Refactor

If you think the record can never be invalid, or don't want to check the return value, use "[save!][2]"

    post = Posts.new do |p|
      p.title = "example"
      p.body = "An example"
    end
    post.save!

Now you will get an error if the `post` cannot be saved, which will alert you to the problem.

## Similar methods

The [record.update_attributes][3] method will also return "false" if it failed to save changes. Just as for `save`, you should check the return value or use [update_attributes!][4].

The [RecordClass.create][5] method may fail to save the newly created method, but will not return `false` in that case. It should be avoided for this reason, and you should always use [RecordClass.create!][6].



  [1]: http://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save
  [2]: http://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21
  [3]: http://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-update_attributes
  [4]: http://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-update_attributes-21
  [5]: http://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-create
  [6]: http://api.rubyonrails.org/classes/ActiveRecord/Validations/ClassMethods.html#method-i-create-21
