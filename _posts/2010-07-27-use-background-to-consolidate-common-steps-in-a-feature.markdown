---
layout: post
title: Use 'Background' to consolidate common steps in a feature
author: Ng Tze Yang
description: Very often, we tend to repeat a number of common steps in all scenarios within a feature, to dry things up, as well as improve readability (helping reader to better focus the intent of each scenario), we can use 'Background'.
tags:
- cucumber
---
Before:

    Scenario: Accessing create post page
      Given I am already signed in as "flyerhzm"
      When I follow "Submit"
      Then I should see "Share a Rails Best Practice" page

    Scenario: Successful create with valid info
      Given I am already signed in as "flyerhzm"
      And I follow "Submit"
      And I fill in the following:
      # (more steps)

After:

    Background:
      Given I am already signed in as "flyerhzm"
      And I follow "Submit"

    Scenario: Accessing create post page
      Then I should see "Share a Rails Best Practice" page

    Scenario: Successful create with valid info
      Given I fill in the following:
      # (more steps)

