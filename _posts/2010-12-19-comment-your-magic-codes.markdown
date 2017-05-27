---
layout: post
title: comment your magic codes
author: Richard Huang
description: Ruby/Rails provides a lot of magic codes, especially for metaprogramming, they are powerful, less codes to implement more functions, but they are not intuition, you should write good comment for your magic codes.
tags:
- convention
- comment
---
Ruby/Rails provides a lot of magic codes, especially for metaprogramming, they are powerful, less codes to implement more functions, but they are not intuition.

You may quickly write the metaprogramming to cleanup your codes, but I promise the magic codes will be strange to you after a few days, and please remember that your magic codes will not be read only by you, you have to write some comments to make your magic codes easy to read and understand.

Here are some example comments I wrote for my projects

![alt text][1]

![alt text][2]

As you seen, I not only add the comments at the top of magic codes, but also add the comments at the right side, replacing the magic codes with normal codes. It makes me much easier to understand what the magic codes do even though I haven't seen the codes for a few months. I think the other developers can also understand these magic codes intuitionally.

  [1]: http://lh4.ggpht.com/_qSmJ0dW70FE/TQ4sVxP2Y6I/AAAAAAAAAWw/LeGVdHiV670/good_comment_1.png
  [2]: http://lh4.ggpht.com/_qSmJ0dW70FE/TQ4sWKxtbUI/AAAAAAAAAW0/4Yw8JumHQNo/good_comment_2.png
