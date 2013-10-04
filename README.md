# Dashing CircleCI Widget

A [Dashing](http://github.com/shopify/dashing) widget for [CircleCI](http://circleci.com)

![](http://f.cl.ly/items/3c0t0v3Z111E0o463032/Screen%20Shot%202013-10-03%20at%208.46.47%20PM.png)

## Requirements

1. [Dashing](http://github.com/shopify/dashing) up and running
2. A [CircleCI](http://circleci.com) account
3. CircleCI [gem](http://github.com/mtchavez/circleci)
4. The contents of this repo to get you set up.

## Setup

1. Add `gem 'circleci'` to your dashing project `Gemfile`
2. `bundle install`
3. `git clone git@github.com:mtchavez/dashing-circleci.git`
4. Copy weather fonts into your dashing project

  ```
  mkdir -p dashing/assets/fonts
  cp dashing-circleci/assets/fonts/weather.* dashing/assets/fonts
  ```
5. Make a config directory and copy sample `circleci.yml` config

  ```
  mkdir -p dashing/config
  cp dashing-circleci/config/circleci.yml dashing/config
  ``` 
6. Copy `CircleCI` widget into your dashing project widgets

  ```
  mkdir -p dashing/widgets/circle_ci
  cp -R dashing-circleci/widgets/circle_ci dashing/widgets/circle_ci
  ```
7. Add `circleci.rb` job to dashing jobs

  ```
  cp dashing-circleci/jobs/circleci.rb dashing/jobs
  ```
8. Optionally copy example dashboard or use as a reference to make your own

  ```
  cp dashing-circleci/dashboards/ci.erb dashing/dashboards
  ```

## Config

The `config/circleci.yml` is used to setup the repositories you want to display.
You will need to modify this file to add your own repositories as well as your CircleCI API token

```yml
token: circle_ci_token 
projects:
  - user: github_username 
    repo: repository_name
    css_id: repo-id
  - user: mtchavez
    repo: dashing-circleci
    css_id: dashing-circleci
```

## Dashboard

To display your dashboard you can use the `dashboards/ci.erb` file in the repo as an example.
An example dashboard for the above config would be

```html
<title>CircleCI</title>
<div class="gridster ready">
  <ul>
    <!-- Row 1 -->
    <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="repo-id" data-view="CircleCi" data-unordered="true" data-title="Repository 1"></div>
    </li>
    <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="dashing-circleci" data-view="CircleCi" data-unordered="true" data-title="Dashing CircleCI"></div>
    </li>
  </ul>
</div>
```

## Job

The job requires the [CircleCI](http://github.com/mtchavez/circleci) gem so make sure that is installed first.

The circleci job only looks at master branches for your repositories. At my current job we found all our topic
and feature branches were too noisy with builds and distracted from the status of our most important branch, master.

There is also a super basic, and probably not very well done, "weather" check of your master branch. Depending
on the last 10 builds of your master branch it will display a different weather icon ala Jenkins.

Currently the job runs once a minute, but you can change that to whatever fits best for you.
