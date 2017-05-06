# danger-circleci

[![Build Status](https://travis-ci.org/rcmachado/danger-circleci.svg?branch=master)](https://travis-ci.org/rcmachado/danger-circleci)

Interact with CircleCI artifacts

## Installation

    $ gem install danger-circleci

## Usage

<blockquote>To show links to artifacts
  <pre>
artifacts = [
  {
    'title' => 'Test Report',
    'path' => "#{ENV['CIRCLE_TEST_REPORTS']}/test/report.html"
  },
  {
    'title' => 'Code Coverage Report',
    'path' => "#{ENV['CIRCLE_TEST_REPORTS']}/cov/index.html"
  }
]
circleci.artifacts_links artifacts</pre>
</blockquote>

### Methods

`artifacts_links` - Show links for build artifacts
`should_display_message` - Checks if we can display the links to artifacts

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
