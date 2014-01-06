# TrackSimply

Setting up your first admin account:

$ bin/rails c

Then enter:

User.create(first_name: "John", last_name: "Smith", email: "john@example.com", password: "your-password", admin: true)
