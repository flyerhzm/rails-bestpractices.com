---
layout: post
title: Use 'Background' to consolidate common steps in a feature
author: Ng Tze Yang (ngty77@gmail.com)
description: Very often, we tend to repeat a number of common steps in all scenarios within a feature, to dry things up, as well as improve readability (helping reader to better focus the intent of each scenario), we can use 'Background'.
tags:
- cucumber
likes:
- shanesveller (shanesveller@gmail.com)
- lucasrenan (lucas@freelancersbrasil.com)
- dylanfm (dylan.fm@gmail.com)
- flyerhzm (flyerhzm@gmail.com)
- soulim (soulim@gmail.com)
- Arnis Lapsa (arnis.lapsa@gmail.com)
- AndrÃ© Moreira ã‚ªã‚¿ã‚¯ ()
- David Westerink (davidakachaos@gmail.com)
- Locke23rus (locke23rus@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
dislikes:
- gdurelle (gregory.durelle@gmail.com)
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

