---
layout: post
title: Use pickle & ur choice factory for data setup in ur cucumber features (revised)
author: Ng Tze Yang
description: Data setup is sometimes painful in features writing for cucumber. Use pickle & factory of ur choice to make it less painful.
tags:
- cucumber
---
Pickle is indeed a *GEM*, use it to make data setup less painful, here are some quick examples:

    # this step creates a post (using factory :post) with title "first best practice"
    Given a post exists with title: "first best practice"

    # this step creates user superman (using factory :superman)
    Given superman exists

    # this step creates a user "superman" (using factory :user) that can be referenced in subsequent steps
    Given a user "superman" exists
    # note the referencing to user "superman" here
    And a post exists with user: user "superman", title: "first best practice"

Using factory for data setup is an elegant solution, & with pickle's nice integration with factory_girl (& machinist, there is really no reason not to use it.

