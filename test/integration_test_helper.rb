require "test_helper"
require "capybara/rails"
require "capybara/poltergeist"

# silence the poltergiest errors such as "Unsafe JavaScript attempt to access frame with URL..."
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    phantomjs_logger: open("/dev/null")
  })
end
Capybara.javascript_driver = :poltergeist

# https://gist.github.com/josevalim/470808
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  def assert_page_has_content(page, content)
    assert page.has_content?(content), "Content Not Found:\n\n\t#{content}"
  end

  def assert_page_has_no_content(page, content)
    assert page.has_no_content?(content), "Unexpected Content Found:\n\n\t#{content}"
  end

  def login_admin
    visit root_path
    fill_in "Email", with: users(:one).email
    fill_in "Password", with: "my-password"
    click_button "Log In"
  end
end
