[![Build Status](https://travis-ci.org/tracksimply/tracksimply.png?branch=master)](https://travis-ci.org/tracksimply/tracksimply) [![Code Climate](https://codeclimate.com/github/tracksimply/tracksimply.png)](https://codeclimate.com/github/tracksimply/tracksimply)

# TrackSimply

Simple, link-based conversion tracking--it's like a URL shortener with awesome analytics.
Use TrackSimply to track traffic and conversions for any link anywhere (mobile, social, email, web, etc.)

## Demo

Check out http://demo.tracksimply.org

## Requirements

- Git
- Ruby 2.1+
- Rails 4.1+
- PostgreSQL

## Getting Started

Setting up your development environment:

```
git clone https://github.com/tracksimply/tracksimply
cd tracksimply
bundle
```

You'll need to setup your .env file, which should NEVER be checked into
you source code repository (it's already ignored in .gitignore)!

```
echo SECRET_KEY_BASE=`rake secret` | cat - .env-sample > .env
```

Edit the .env file to make sure the value for HTTP_HOST is correct. The last
step is to add your own admin account from the rails console:

```
bin/rails c
irb(main):001:0> User.create(first_name: "John", last_name: "Smith", email: "john@example.com", password: "your-password", admin: true)
```

Then start your server:

```
foreman start
```
