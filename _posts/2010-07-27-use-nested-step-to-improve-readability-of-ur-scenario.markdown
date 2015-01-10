---
layout: post
title: Use nested step to improve readability of ur scenario
author: Ng Tze Yang (ngty77@gmail.com)
description: When a scenario has too many steps, it becomes hard to read & follow. Using nested step helps to clean up the scenario, & helps promote reusability of groups of steps, think of it as code refactoring.
tags:
- cucumber
likes:
- shanesveller (shanesveller@gmail.com)
- dylanfm (dylan.fm@gmail.com)
- Arnis Lapsa (arnis.lapsa@gmail.com)
- Locke23rus (locke23rus@gmail.com)
- juancolacelli (juancolacelli@gmail.com)
dislikes:
- 
---
Before:

    Scenario: Accessing create post page
      Given flyerhzm exists
      And a post exists with title: "first best practice"
      And I go to login page
      And I fill in "Username" with "flyerhzm"
      And I fill in "Password" with "flyerhzm"
      And I press "Login"      
      When I follow "Submit"
      Then I should see "Share a Rails Best Practice" page

After:

    Scenario: Accessing create post page
      Given I am already signed in as "flyerhzm"
      When I follow "Submit"
      Then I should see "Share a Rails Best Practice" page

And the corresponding step definition:

    # features/step_definitions/custom_web_steps.rb
    Given %r{^I am already signed in as "([^"]*)"$} do |someone|
      user = Factory.build(someone)
      Given "#{someone} exists" rescue nil
      And %|I go to login page|
      And %|I fill in "Username" with "#{user.login}"|
      And %|I fill in "Password" with "#{user.password}"|
      And %|I press "Login"|
    end

