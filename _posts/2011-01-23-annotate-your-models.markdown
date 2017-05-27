---
layout: post
title: Annotate your models
author: Richard Huang
description: Are you tired of going to schema.rb to find your table structures information? It would be better to list all the attributes of the model in the model itself.
tags:
- model
- gem
- comment
---
Before
---------

The fact that rails dynamically creates the model attributes at runtime saves repetitive typing, but I find it difficult to discover what attributes exist on model class. I have to go to schema.rb to find the table structure information. For example, I have two models Post and Comment,

    class Post < ActiveRecord::Base
      has_many :comments
    end

    class Comment < ActiveRecord::Base
      belongs_to :post
    end

The two models are defined in post.rb and comment.rb files, from these two files, it is impossible to know what attributes the Post and Comment models have. It may not be a big problem when you create and define the two models, but what about the other developers? They don't know anything about these two models when they first read these two models. They have to go to the schema.rb to discover what attributes.

    ActiveRecord::Schema.define(:version => 20101223141603) do
      create_table "posts", :force => true do |t|
        t.string   "title"
        t.text     "body"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "user_id"
      end

      create_table "comments", :force => true do |t|
        t.text     "body"
        t.integer  "post_id"
        t.integer  "user_id"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end

After reading the schema.rb, we know the Post model has attributes title and body, and the Comment model has attributes body.

I'm tired of always going to the schema.rb to find what attributes the models have, it wastes my time, of course yours, why not list them in the models themselves?

After
-------

Some other model frameworks such as datamapper, mongomaper and mongoid directly define the attributes in the models, I really prefer their manner. As ActiveRecords uses migration/schema.rb to manage the attributes of models, we can't define the attributes in models directly, but we can drop the table structures information in models in the form of comments. Here I highly recommend [annotate][1] gem, it will automatically add the comments at the top or bottom of your models to list the table structures information. The following are the results after annotate works.

    # == Schema Information
    #
    # Table name: posts
    #
    #  id             :integer(4)      not null, primary key
    #  title          :string(255)
    #  body           :text(16777215)
    #  created_at     :datetime
    #  updated_at     :datetime
    #  user_id        :integer(4)
    #
    class Post < ActiveRecord::Base
    end

    # == Schema Information
    #
    # Table name: comments
    #
    #  id               :integer(4)      not null, primary key
    #  body             :text(16777215)
    #  post_id          :integer(4)
    #  user_id          :integer(4)
    #  created_at       :datetime
    #  updated_at       :datetime
    #
    class Comment < ActiveRecord::Base
    end

It's pretty amazing, I never need to go to the schema.rb anymore. It's an intuitive manner to discover all the attributes of the models.

  [1]:https://github.com/ctran/annotate_models
