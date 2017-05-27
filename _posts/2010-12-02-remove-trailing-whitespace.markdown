---
layout: post
title: remove trailing whitespace
author: Richard Huang
description: Trailing whitespace always makes noises in version control system, it is meaningless. We should remove trailing whitespace to avoid annoying other team members.
tags:
- whitespace
- version control
---
I can't remember how many times the trailing whitespace makes noises in my git commits, like

![alt text][1]

the trailing whitespace makes no sense and it always annoys other team members.

To collaborate better with others, we should form a habit to remove trailing whitespace before committing. There are a lot of ways to do it,

we can remove whitespace by ourselves, but it's easy often to forget to do as the trailing whitespace is invisible by default.

we can set a git pre commit hook to detect/remove trailing whitespace, that's fine and please remember to use the pre commit hook for every projects.

**The best way is to remove trailing whitespace before saving a file within your ide.** I prefer using Vim and TextMate, here's my solution.

For TextMate, you can just install [uber-glory-tmbundle][2], it's really easy.

For Vim, you should add the following codes in your ~/.vimrc file.

    " Strip trailing whitespace
    function! <SID>StripTrailingWhitespaces()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " Do the business:
        %s/\s\+$//e
        " Clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

There are similar solutions to other ides (Emacs, Netbeans, etc.), but I don't use them. If you know, please write a comment, thanks.

After your team all set up removing trailing whitespace in your ides, you will never see the trailing whitespace noises in git commits again.


  [1]: http://lh5.ggpht.com/_qSmJ0dW70FE/TPfBQjvbHQI/AAAAAAAAAWA/U7BUO-LzHwU/git%20diff.png
  [2]: https://github.com/glennr/uber-glory-tmbundle
