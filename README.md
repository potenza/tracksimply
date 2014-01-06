# TrackSimply

Setting up your development environment:

## Requirements

- Ruby 2.0+
- Postgresql

$ gem install foreman
$ git clone https://github.com/tracksimply/tracksimply
$ cd tracksimply
$ bundle

You'll need to setup your .env file, which should NEVER be checked into
you source code repository (it's already ignored in .gitignore)!

$ echo SECRET_KEY_BASE=`rake secret` | cat - .env-sample > .env

Edit the .env file to make sure the value for HTTP_HOST is correct.

Then, just add your admin account:

$ bin/rails c

Then enter:

User.create(first_name: "John", last_name: "Smith", email: "john@example.com", password: "your-password", admin: true)

Then start your server:

$ foreman start
