---
layout: post
title: rolling out with feature flags
author: Richard Huang
description: Sometimes you may face the situation that some features will be released, but you are not sure if it is friendly to end user, or if it will lead to performance issues, at that time you should use what we called "feature flags"
tags:
- performance
---
Rolling out with feature flags means the released feature can be fully or partially turn on/off at the running time. We have a private repository named feature_flags, it allows to release some features to production, but the features are disabled by default, we can activate it after deployment, we can activate it to specific users, to user percentages (like 50% users), or to all users.

## Use Cases

Here are some use cases we use feature flags in our product:

**1\. a/b testing**, we tried to release a new landing page before to see if it can increase the user sign in percentage. This is the feature flag logic to render different pages,

    if $features.active?(:new_landing_page, current_user)
      # render new landing page
    else
      # render old landing page
    end

we can activate our own account to verify new landing page rendered correctly

    $features.activate_object(:new_landing_page, internal_user)

and activate 50% users by

    $features.activate_group(:new_landing_page, "users", 50)

and then activate all users by

    $features.activate_all(:new_landing_page)

after we decided to use new landing page, we can just remove old landing page, and remove the feature flag code in the next deployment.

**2\. performance verification**, when we have a new feature to release, but can't promise it won't affect server performance, we will add feature flags to verify it on production, and turn on the feature gradually, like

    $features.activate_group(:heavy_feature, "users", 10) # activate the heavy feature to 10% users
    $features.activate_group(:heavy_feature, "users", 20) # activate the heavy feature to 20% users
    $features.activate_group(:heavy_feature, "users", 50) # activate the heavy feature to 50% users
    ......

We will keep monitoring our server performance, it we saw any spike, we will disabled the feature, figure out the root cause and try another way to solve the performance issue.

    $features.deactivate_all(:heavy_feature)

**3\. external services**, our product uses some external services, like using twitter for sign up/in and social promotion, using airbrake for exception notification, etc. But if these external services go under maintenance, our product will break as well. So we add feature flags to these external services as well, e.g. if airbrake goes down, we just turn off the feature

    $features.deactivate_all(:airbrake)

and then turn on it after airbrake goes on

    $features.activate_all(:airbrake)


It works very well in our product, but unfortunately feature_flags is still our own private repository, you can't use it now, please don't blame me. But after searching on github, I found [jamesgolick's rollout][0] gem, which provides very similar functionalities and it is open sourced, you can try it.

[0]: https://github.com/jamesgolick/rollout
