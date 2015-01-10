---
layout: post
title: Substituting before_filter :load_object
author:  (mail@dennisbloete.de)
description: Instead of loading an object with a before_filter you can use a more intelligent helper_method to get the main object for the controller context.
tags:
- controller
- model
- view
- helper
likes:
- dbloete (mail@dennisbloete.de)
- Hitesh Manchanda ()
- David Westerink (davidakachaos@gmail.com)
- aleks (ihunte@gmail.com)
- avocade (avocade@gmail.com)
- railsjedi (railsjedi@gmail.com)
- leobessa (leobessa@gmail.com)
- Hugues ()
- juancolacelli (juancolacelli@gmail.com)
- matthewcford (matt@bitzesty.com)
- des (Ijon57@gmail.com)
- whitethunder (mattw922@gmail.com)
- tarasevich (tarasevich.a@gmail.com)
- tekin (tekin@tekin.co.uk)
- eagleas (eagle.alex@gmail.com)
dislikes:
- iceydee (mionilsson@gmail.com)
- Locke23rus (locke23rus@gmail.com)
---
Here's a Rails controller pattern I'm using more often lately: Instead of loading an object with a <code>before_filter</code> you can use a more intelligent <code>helper_method</code> to get the main object for the controller context. It already sounds more complicated than it is, so here's an example:

**Before**

<pre lang="ruby">class ProductController < ApplicationController
  before_filter :load_product, :only => [:show, :edit, :update, :destroy]
  
  # your standard CRUD methods here…

  private

  def load_product
    @product = Product.find(params[:id])
  end
end</pre>

This is pretty straight forward and I assume everyone has done that already, here's a <em>imho</em> nicer approach… 

**After**

<pre lang="ruby">class ProductController < ApplicationController
  helper_method :product
  
  …

  def create
    respond_to do |format|
      if product.save
        format.html { redirect_to product }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if product.update_attributes(params[:product])
        format.html { redirect_to product }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
    end
  end
  
  private

  def product
    @product ||= params[:id] ? Product.find(params[:id]) : Product.new(params[:product])
  end
end</pre>

And beacause it is a helper method you can use it in your views just like that, for example in conjunction with a form:

<pre lang="haml">%h1 New product

- form_for product do |f|
  …</pre>

Of course you can adjust the helper method to fit your needs, maybe you need it to provide a nested object:

<pre lang="ruby">class ProductController < ApplicationController
  helper_method :category, :product
  
  def index
    @products = catalog.products
  end

  # you get the idea…

  private
  
  def catalog
    @catalog ||= params[:catalog_id] ? Catalog.find(params[:catalog_id]) : Catalog.new(params[:catalog])
  end

  def product
    @product ||= params[:id] ? catalog.products.find(params[:id]) : catalog.products.build(params[:product])
  end
end</pre>
