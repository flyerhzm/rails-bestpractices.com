---
layout: post
title: Keep Finders on Their Own Model
author: Wen-Tien Chang (ihower@gmail.com)
description: According to the decoupling principle, model should do finders by itself, a model should not know too much about associations finders logic.
tags:
- rails2
- model
likes:
- ihower (ihower@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- mikhailov (mikhailov.anatoly@gmail.com)
- cash (ashley.c.woodard@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- boostbob (1982wb@gmail.com)
- bugmenot (fhugfizn@sharklasers.com)
dislikes:
- 
---
Bad Smell
---------

    class Post < ActiveRecord::Base
      has_many :comments
    
      def find_valid_comments
        self.comment.find(:all, :conditions => {:is_spam => false},
                                :limit => 10)
      end
    end
    
    class Comment < ActiveRecord::Base
      belongs_to :post
    end
    
    class CommentsController < ApplicationController
      def index
        @comments = @post.find_valid_comments
      end
    end

According to the decoupling principle, model should do finders by itself, a model should not know too much about associations finders logic. In here, Post model handle the complex finder of comments, but this is not its job, we should move valid comments finder to the Comment model.

Refactor
--------

    class Post < ActiveRecord::Base
      has_many :comments
    end
    
    class Comment < ActiveRecord::Base
      belongs_to :post
    
      named_scope :only_valid, :conditions => { :is_spam => false }
      named_scope :limit, lambda { |size| { :limit => size } }
    end
    
    class CommentsController < ApplicationController
      def index
        @comments = @post.comments.only_valid.limit(10)
      end
    end

We move the valid comments finder from Post model to Comment model, and make it as named_scope. So the Post and Comment models are loose coupled now and much easier to extend.
