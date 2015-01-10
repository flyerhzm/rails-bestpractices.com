---
layout: post
title: Use cells to abstract view widgets
author: Richard Huang (flyerhzm@gmail.com)
description: Rails developers always pay more attentions on models and controllers refactoring, they don't take care about views modularization, that makes view codes most difficult to maintain. Here I recommend you to use cells gem to write more reuseable, testable and cacheable view codes.
tags:
- view
- cells
likes:
- flyerhzm (flyerhzm@gmail.com)
- iGEL (igel@igels.net)
- juancolacelli (juancolacelli@gmail.com)
- Raecoo (raecoo@gmail.com)
- wangyingan (wangyingan@gmail.com)
- jarrod.spillers (jarrod@jtms.net)
- luckyjazzbo (luckyjazzbo@gmail.com)
- theCrab (nelson@21waves.com)
- milushov (rails-bestpractices@milushov.ru7)
- mayinx (mayinxx@web.de)
dislikes:
- 
---
Rails developers have a strong idea to write beautiful and high quality ruby codes for models and controllers, they always try to write test codes and refactor existing ruby codes. That's great, but what about view codes? Do you have ever abstract your view codes? Do you test your view codes?

My experience is it's inconvenient to test view codes in rails, which makes developers not to refactor their view codes. I'm using **[Cells][1]** recently which make me very happy to refactor my view codes, make view codes more reusable, testable and cacheable.

Useable
------------

When saying reusable view codes, most of rails developers will think of partial views or helpers, but I don't think they are good.

 1. Partial views always access variables sitting in the controllers, which increases controller complexity.
 2. Partial views can't be test separately.
 3. Helpers are global accessed in views, that means different methods with same name will be conflicted although they are defined in different helpers.
 4. Helpers are not good place to write complex html codes.

A cell is small controller, methods in cell are like actions, they will read data and render corresponding view widgets, they accepts objects as input, the view widgets are outputs.

This is an example to define a Cell

    # app/cells/sidebar_cell.rb
    class SidebarCell < Cell::Rails
      def recent_posts
        @posts = Post.order("created_at desc").limit(5)
        render
      end
    end

    # app/cells/sidebar/recent_posts.html.haml
    .posts-section
      %h3 Recent Posts
      %ul
        - @posts.each do |post|
          %li= link_to post.title, post_path(post)

This Cell is used to render recent posts view widget in the sidebar, you may guess how it works, the same as controller/view in rails. In cell, it reads the recent 5 posts, then render the recent posts view widget.

Then how do we use this cell?

    # app/views/layout/application.html.haml
    = render_cell :sidebar, :recent_posts

The advantage of cells is that it makes view widgets MVC as well, cool! I love it.

Testable
------------

Rails provides some helpers to test view codes, but it's still a pain to test view codes. For example, if you are developing a online shopping system, how do you test cart widget in pages? Cart widget should exist in every page, which page should you test the cart widget? home page or purchase page? It's not easy to decide, most of the time it leads to tests the same functionality in page multiple times.

Cells modularize the view codes, so you can test the view widget independent, without testing a widget in a whole page. Let me show you an example.

    # app/cells/posts_cell.rb
    class PostsCell < Cell::Base
      def tag_cloud
        @tags = Post.tag_counts_on(:tags)
        render
      end
    end

    # app/cells/posts/tag_cloud.html.haml
    - tag_cloud(@tags, %w(css1 css2 css3 css4 css5)) do |tag, css_class|
     = link_to tag.name, tag_posts_path(tag.name), :class => css_class

This posts_cell abstract tag_cloud view widget, now we can focus on testing this view widget.

    # spec/cells/posts_cell_spec.rb
    require 'spec_helper'

    describe PostsCell do
      context "cell rendering" do
        context "renderding tag_cloud" do
          before do
            @post1 = Factory(:post, :tag_list => "ruby, rails")
            @post2 = Factory(:post, :tag_list => "ruby")
          end
          subject { render_cell(:posts, :tag_cloud) }

          it { should have_link("ruby") }
          it { should have_link("rails") }
        end
      end

      context "cell instance" do
        subject { cell(:posts) }
        it { should respond_to(:tag_cloud) }
      end
    end

As you seen, cells makes view codes more testable, you can write more small view widgets and test them, it will make your view codes more robust.

Cacheable
---------------

You are probably using fragment cache in view codes, like

    # app/views/posts/show.html.erb
    <% cache "posts/#{post.id}/#{post.comment_count}" do %>
      <h3>Comments:</h3>
      <ul>
        <%- @post.comments.each do |comment| %>
          ......
        <% end %>
      </ul>
    <% end %>

Fragment cache is not good as you have to insert the cache code into view codes, which makes view codes a bit ugly, page cache and action cache are better as they are declarative, they don't need to break the existing logic codes.

In cells, it's using declarative cache as well

    # app/views/posts/show.html.erb
    <%= render_cell :comment, :list, post %>

    # app/cells/comment_cell.rb
    class CommentCell < Cell::Rails
      cache :list do |cell, post|
        "posts/#{post.id}/#{post.comments_count}"
      end
      def list(post)
        @comments = post.comments
        render
      end
    end

    # app/cells/comment/list.html.erb
    <h3>Comments:</h3>
    <ul>
      <%- @comments.each do |comment| %>
        ......
      <% end %>
    </ul>

Here, we cache the post's comments view widget, adding a new comment will generate a view widget cache, you can also add condition to tell the cells it should be cached or not, like action_cache

    class HeaderCell < Cell::Rails
      cache :show, :if => proc { |cell, user| !user }
      ......
    end

it tells cells to cache the header widget if the user is not logged in, don't cache header widget as it contains some dynamic data.

As view widgets are always small, it's easier for you to apply cache on the widgets.

Read more information about Cells [here][1]


  [1]: https://github.com/apotonick/cells "cells"
