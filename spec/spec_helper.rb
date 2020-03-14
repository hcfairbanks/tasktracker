require 'factory_bot_rails'
require 'rubygems'
require 'mocha/api'

RSpec.configure do |config|

  config.mock_with :mocha
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    #  This are needed before a user can be created or lo
    Role.create(name: "admin")
    Role.create(name: "business")
    Role.create(name: "unassigned")
  end

  config.after(:each) do
    FileUtils.rm_rf( Rails.root.join("dynamic_files","test"))
  end
  def admin_login
    admin = User.new
    admin.first_name = "John"
    admin.last_name = "Doe"
    admin.password ='123456'
    admin.email = "testadmin@test.com"
    admin_role = Role.find_by_name('admin')
    admin.role = admin_role
    admin.avatar = Rails.root.join("spec/fixtures/binaries/headshots/1.jpg").open
    admin.save!
    session[:user_id] = admin.id
    admin
  end
end
