---
layout: post
title: Use memoization
author: Richard Huang (flyerhzm@gmail.com)
description: Memoization is an optimization technique used primarily to speed up computer programs by having function calls avoid repeating the calculation of results for previously-processed inputs. In rails, you can easily use memoize which is inherited from ActiveSupport::Memoizable.
tags:
- performance
likes:
- flyerhzm (flyerhzm@gmail.com)
- Vijay Dev ()
- Fabrice (fabrice@lunaweb.fr)
- David Westerink (davidakachaos@gmail.com)
- kamui (kamuigt@gmail.com)
- Mikhail ()
- José Galisteo Ruiz ()
- Kevin Ansfield ()
- Roger Campos (roger@itnig.net)
- Roger Campos (roger@itnig.net)
- mattiasjes (mpj@mpj.me)
- ben (benz303bb@gmail.com)
- iceydee (mionilsson@gmail.com)
- itima_ru (alexey@itima.ru)
- marsbomber (jimli@elinkmedia.net.au)
- 360andless (beanie@benle.de)
- ecleel (ecleeld@gmail.com)
- donortools (ryan@donortools.com)
- donortools (ryan@donortools.com)
- des (Ijon57@gmail.com)
- romanvbabenko (romanvbabenko@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- anga (andres.b.dev@gmail.com)
- yorzi (wangyaodi@gmail.com)
- gri0n (lejazzeux@gmail.com)
- Arkham (liuju86@gmail.com)
- frp (franchukrom@gmail.com)
- dmdv (dimos-d@yandex.ru)
- jaredobson (jared.dobson@live.com)
- knightq (andrea.salicetti@gmail.com)
- PsiCat (ogealter@gmail.com)
- leolukin (leolukin@gmail.com)
- dimianstudio (dimianstudio@gmail.com)
- beata (nahoyabe@gmail.com)
- nabinno (nab@blahfe.com)
dislikes:
- 
---
Memoization is an optimization technique used primarily to speed up computer programs by having function call avoid repeat the calculation of results for previously-processed input. Here I will give you an example.

Problem
------------

Imagine you have a billing system that one user has many accounts, each account has its own budget, there is a method total_budget for user object, which calculate the summary of all the available accounts' budgets. The following is the model definition.

    class User < ActiveRecord::Base
      has_many :available_accounts, :class_name => 'Account', :conditions => "budget > 0"

      def total_budget
        self.available_accounts.inject(0) { |sum, a| sum += a.budget }
      end
    end

total_budget will be used multiple times in models, views and controllers, such as

    <% if current_user.total_budget > 0 %>
      <%= current_user.total_budget %>
    <% end %>

every time you use the total_budget, there is a db query sent to retrieve all available accounts for the user, and then calculate the summary of all the available accounts' budgets. How can we avoid the duplicated db query and duplicated calculation?

Caching with instance variable
--------------------------------------------

There is an easy solution to use caching with instance variable to avoid the duplication execution.

    class User < ActiveRecord::Base
      has_many :available_accounts, :class_name => 'Account', :conditions => "budget > 0"

      def total_budget
        @total_budget ||= self.available_accounts.inject(0) { |sum, a| sum += a.budget }
      end
    end

That means the first time you call total_budget, one db query will be sent, calculate the summary of budgets, then assign the summary to the instance variable @total_budget. The second time you call total_budget, no db query be sent and no calculation execute, just return the @total_budget directly.

If your returned value is non-true, like nil or false, you must use the following solution

    def has_comment?
      return @has_comment if defined?(@has_comment)
      @has_comment = self.comments.size > 0
    end

Memoizable
-----------------

The problem with this memoization is that you have to litter your method implementation with caching logic.Memorization should be best applied in a transparent way.

From Rails 2.2, there is a transparent way to implement memoization by using memoize inherited from ActiveSupport::Memoizable.

    class User < ActiveRecord::Base
      extend ActiveSupport::Memoizable

      has_many :available_accounts, :class_name => 'Account', :conditions => "budget > 0"

      def total_budget
        self.available_accounts.inject(0) { |sum, a| sum += a.budget }
      end
      memoize :total_budget
    end

memoize method will help you cache the method result automatically, you don't need to change the method implementations anymore, what you want to do is just declare what methods should be memoization.

The other big issue for caching with instance variable is that it's inconvenient to cache the different result depends on different inputs. Let's define a new method total_spent.

    class User < ActiveRecord::Base
      extend ActiveSupport::Memoizable

      has_many :available_accounts, :class_name => 'Account', :conditions => "budget > 0"

      def total_budget
        self.available_accounts.inject(0) { |sum, a| sum += a.budget }
      end

      def total_spent(start_date, end_date)
        self.available_accounts.where('created_at >= ? and created_at <= ?', start_date, end_date).inject(0) { |sum, a| sum += a.spent }
      end
      memoize :total_budget, :total_spent
    end

it's really inconvenient to cache the total_spent result by using instance variable, as the results of total_spent are different when passing different start_date and end_date. But memoize can do it as easy as memoization for methods without arguments, it will cache the different results according to different inputs.

Deprecation
-----------------

It does not say use memoization is deprecated, it's ActiveSupport::Memoize module was deprecated in Rails 3.2, see the [commit][1], josevalim prefers "use Ruby instead", it is the same solution I mentioned in Caching with instance variable, but ActiveSupport::Memoize provides more features than direct @var ||= solution, like

 1. correctly memoize non-true values (nil, false, etc)
 2. varias memoization by method parameters
 3. separate cached return value from variable instances

So if you still want to enjoy these extra bonuses, try [memoist][2] gem, it is an direct extraction of ActiveSupport::Memoizable.


  [1]: https://github.com/rails/rails/commit/36253916b0b788d6ded56669d37c96ed05c92c5c
  [2]: https://github.com/matthewrudy/memoist
