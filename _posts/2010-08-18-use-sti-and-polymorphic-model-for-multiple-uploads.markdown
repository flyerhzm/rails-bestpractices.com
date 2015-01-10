---
layout: post
title: Use STI and polymorphic model for multiple uploads
author: Richard Huang (flyerhzm@gmail.com)
description: This is a flexible and reusable solution for multiple uploads, using STI model to save all the uploaded assets in one "assets" table and using polymorphic model to reuse "Asset" model in different uploadable models.
tags:
- model
- upload
likes:
- flyerhzm (flyerhzm@gmail.com)
- questioner (questioner@gmail.com)
- mrpink (jantzeno@msn.com)
- mlanza (mlanza@comcast.net)
- timurv (me@timurv.ru)
- ahinni (aaron@vedadev.com)
- chaserx (chase.southard@gmail.com)
- matthewcford (matt@bitzesty.com)
- juancolacelli (juancolacelli@gmail.com)
- Locke23rus (locke23rus@gmail.com)
- megatux (megatux@gmail.com)
- shemerey (shemerey@gmail.com)
- arunkumar339 (arunkumar339@gmail.com)
- lisovskyvlad (lisovskyvlad@gmail.com)
- beata (nahoyabe@gmail.com)
dislikes:
- eimantas (eimantas@vaiciunas.info)
- José Galisteo Ruiz ()
---
This is extracted from my answer of [How do you design your model for multiple upload?][1]

I have built several rails applications, most of them allow user to upload assets, such as images and videos. It's easy if there is only one or two assets to upload, but it makes your code in a mess to deals with many uploading assets.

Here I give you a flexible and reusable solution for multiple uploads by using STI and polymorphic model, the solution use paperclip for uploading, it's just an example, you can use other ways for uploading.

Image you are dealing with a system that allow user to upload different kinds of assets, for example, user can upload many images and a video for a Post, upload a logo for a Site, and upload many images for a Question. How do you design the models for such system?

I always use STI and polymorphic model because I save all the uploaded assets in assets table and reuse the Asset model.

For this case, I will define the Asset models as follows

    # app/models/asset.rb
    class Asset < ActiveRecord::Base
      belongs_to :assetable, :polymorphic => true
      delegate :url, :to => :attachment
    end

    # app/models/post/video.rb
    class Post::Video < Asset
      has_attached_file :attachment, :processors => [:flash], :styles => {:default => ["400x300>", "flv"]}
    end

    # app/models/post/image.rb
    class Post::Image < Asset
      has_attached_file :attachment, :styles => { :small => "200x150>", :large => "400x300>" }
    end

    # app/models/site/logo.rb
    class Site::Logo < Asset
      has_attached_file :attachment, :styles => { :default => "64x64>" }
    end

    # app/models/question/image.rb
    class Question::Image < Asset
      has_attached_file :attachment, :styles => { :small => "200x150>", :large => "400x300>" }
    end

As you seen, all the uploaded assets (including video and images of post, logo of site and images of question) are saved in "assets" table by STI model. The video upload is not supported by paperclip, you should define your own processor to process the video. The assets table definition is like

    create_table :assets, :force => true do |t|
      t.string   :type
      t.integer  :assetable_id
      t.string   :assetable_type
      t.string   :attachment_file_name
      t.string   :attachment_content_type
      t.integer  :attachment_file_size
      t.datetime :attachment_updated_at
    end

The column type is for STI, so you can save Post::Video, Post::Image, Site::Logo and Question::Image in one assets table, and the assetable_id and assetable_type are for polymorphic, so you can reuse the "Asset" model in different uploadable models, here are Post, Site and Question.

So the relationships between asset and post, site, question are polymorphic as follow

    # app/models/post.rb
    class Post < ActiveRecord::Base
      has_one :video, :as => :assetable, :class_name => "Post::Video", :dependent => :destroy
      has_many :images, :as => :assetable, :class_name => "Post::Image", :dependent => :destroy
      
      accepts_nested_attributes_for :video, :images
    end

    # app/models/site.rb
    class Site < ActiveRecord::Base
      has_one :logo, :as => :assetable, :class_name => "Site::Logo", :dependent => :destroy
      
      accepts_nested_attributes_for :logo
    end

    # app/models/question.rb
    class Question < ActiveRecord::Base
      has_many :images, :as => :assetable, :class_name => "Question::Image", :dependent => :destroy
      
      accepts_nested_attributes_for :images
    end

Be attention that I add the accepts_nested_attributes_for for models who needs to upload assets so that I can easily to create or update object and assets with nested form.

    <%= form_for @post, :html => {:multipart => true} do |form| %>
      <p>
        <%= form.label :name %>
        <%= form.text_field :name %>
      </p>
      <%= form.fields_for :video do |video_form| %>
        <p>
          <%= logo_form.label :video %>
          <%= logo_form.file_field :attachment %>
        </p>
      <% end %>
      <%= form.fields_for :images do |image_form| %>
        <p>
          <%= image_form.label :image %>
          <%= image_form.file_field :attachment %>
        </p>
      <% end %>
      <p>
        <%= form.submit %>
      </p>
    <% end %>

Before you handle the form, be sure you have build assets objects, such as build a logo for post object and build 4 images for post object.

    def new
      @post = Post.new
      @post.build_video
      4.times do
        @post.images.build
      end
    end

Then you can save the post object with uploaded assets as normal
  
    def create
      @post = Post.new(params[:post])
      if @post.save
        redirect_to post_path(@post)
      else
        render :action => :new
      end
    end

Here is the way to display the images for post.

    <%- @post.images.each do |image| %>
      <%= image_tag image.url(:small) %>
    <% end %>

This is a flexible and reusable solution.

Updated: thanks @reu for suggesting me to add a delegate url to attachment in Asset model.


  [1]: http://rails-bestpractices.com/questions/7-how-do-you-design-your-model-for-multiple-upload
