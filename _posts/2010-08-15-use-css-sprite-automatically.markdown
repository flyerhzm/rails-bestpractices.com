---
layout: post
title: Use css sprite automatically
author: Richard Huang (flyerhzm@gmail.com)
description: Using css sprite can reduce a large number of http requests, so it makes the web page loaded much faster. It it painful to composite a lot of images manually, do it automatically.
tags:
- plugin
- performance
- css sprite
- convention
- assets
likes:
- flyerhzm (flyerhzm@gmail.com)
- questioner (questioner@gmail.com)
- Cédric Darricau ()
- mattiasjes (mpj@mpj.me)
- zcq100 (zcq100@gmail.com)
- des (Ijon57@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
- anga (andres.b.dev@gmail.com)
- luckyjazzbo (luckyjazzbo@gmail.com)
- PsiCat (ogealter@gmail.com)
dislikes:
- 
---
The advantage of using the css sprite is to reduce a large number of http requests, so it makes the web page loaded much faster. I often find it is painful to compose a lot of images into one css sprite image and measure the x and y positions for each image. Besides this, it always causes conflict when more than one person change the css sprite image.

So I wrote a [css_sprite][1] gem to make css sprite automatically and intelligently, it follows the idea of Convention Over Configuration.

First, let's look at the convention of the directory structrue.

![css_sprite_preview][2]

The blue parts on the above image are the css_sprite directories according to convention. That means the directory whose name is css_sprite or css_sprite suffixed (e.g. another_css_sprite) needs to do the css sprite.

The green parts are images that need to be tranformed into the css sprite. Once you add images to the css_sprite directory or remove images, the css sprite operation will be automatically executed.

The red parts are automatically generated files. For each css_sprite directory, there is a css sprite image generated, combined by all the images under the css_sprite directory, and there is also a css or sass file generated according to the css_sprite image.

What about the generated css file?

    .twitter_icon, .facebook_icon, .login_button, .logout_button {
      background: url('/images/css_sprite.png?1270170265') no-repeat;
    }
    .twitter_icon { background-position: 0px 0px; width: 14px; height: 14px; }
    .facebook_icon { background-position: 0px -19px; width: 14px; height: 14px; }
    .login_button { background-position: 0px -38px; width: 103px; height: 36px; }
    .logout_button { background-position: 0px -79px; width: 103px; height: 36px; }

That means, the generated css file follows the naming convention: **one image under the css_sprite directory corresponds to one class in the generated css file, the name of class is just the same as the name of image**. The advantage of this is that developers only need to know what images are under css_sprite directory, then they can use the corresponding class names to display these images on the html page.

Follow these rules, what you need to do is to put a new image into the css_sprite directory, then use the corresponding class name to display the image on html page. Generating css sprite image and css files are done automatically. Of course when I remove an image from the css_sprite directory, it is also removed from css_sprite image and css.

These are css sprite best practice I follow. Now it's time to see how to implement these in a rails application.

1. install the css_sprite gem

2. create css_sprite or css_sprite suffixed directory, and put any images into the css sprite directory.

3. you can use "rake css_sprite:start" to generate css sprite image automatically all the time, or use "rake css_sprite:build" to run the css_sprite once manually.

4. then add the stylesheet "css_sprite.css" in html and use the generated css class to display image.

The css_sprite gem also supports to generate sass and scss.

And to avoid the conflict of css sprite image and css, add public/images/css_sprite.png and public/stylesheets/css_sprite.css into .gitignore file. So only images under css sprite directory are in the control of git, and everyone should build the css sprite image automatically by the rake task.

Don't hesitate to use the [css_sprite][1] to speed up your productivity.

  [1]: http://github.com/flyerhzm/css_sprite
  [2]: http://lh6.ggpht.com/_qSmJ0dW70FE/TGdIAsGI6_I/AAAAAAAAATo/3Xhs9JzvDAQ/css_sprite_preview.png
