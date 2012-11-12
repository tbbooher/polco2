require 'rbconfig'
#HOST_OS = RbConfig::CONFIG['host_os']
source 'https://rubygems.org'
gem 'rails', '3.2.8'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'chosen-rails'
end

gem 'jquery-rails'
gem "haml", ">= 3.1.4"
gem "haml-rails", ">= 0.3.4", :group => :development
gem "rspec-rails", ">= 2.11.0", :group => [:development, :test]
gem "database_cleaner", ">= 0.7.2"
gem "mongoid-rspec", ">= 1.4.4", :group => :test
gem "factory_girl_rails", ">= 4.1.0", :group => [:development, :test]
gem "email_spec", ">= 1.2.1", :group => :test
gem "guard", ">= 0.6.2", :group => :development

gem 'thin'

#case HOST_OS
#  when /darwin/i
#    gem 'rb-fsevent', :group => :development
#    gem 'growl', :group => :development
#  when /linux/i
#    gem 'libnotify', :group => :development
#    gem 'rb-inotify', :group => :development
#  when /mswin|windows/i
#    gem 'rb-fchange', :group => :development
#    gem 'win32console', :group => :development
#    gem 'rb-notifu', :group => :development
#end
gem 'inherited_resources'

gem "guard-bundler", ">= 0.1.3", :group => :development
gem "guard-rails", ">= 0.0.3", :group => :development
gem "guard-livereload", ">= 0.3.0", :group => :development
gem "guard-rspec", ">= 0.4.3", :group => [:development, :test]
gem "bson_ext", ">= 1.6.2"
gem "mongoid", ">= 3.0.6"
gem "omniauth", ">= 1.0.3"
gem "omniauth-github"
gem "bootstrap-sass", ">= 2.0.1"
gem "simple_form"
gem "heroku"

gem "capybara", :group => :test
gem 'launchy', :group => :test
gem "spork", :group => :test
gem "guard-spork", :group => :test
gem "faker", :group => [:test, :development]
#gem "mongoid_counter_cache"

gem 'feedzirra'
gem 'sax-machine'
gem 'httparty'
gem 'kaminari'
gem 'geocoder'
gem 'gon'
#gem 'thor'