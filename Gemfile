source 'https://rubygems.org'
ruby '2.4.1'
gem 'rails', '~> 5.1', '>= 5.1.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

#### Front End Gems

# Use HAML for HTML preprocessor
gem 'haml', '~> 5.0', '>= 5.0.1'
gem 'haml-rails', '~> 1.0'
# Use SASS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.6'
# Use bootstrap for front-end framework
gem 'bootstrap', '~> 4.0.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

# bootstrap dependency
gem 'popper_js', '>= 1.12.3'

# Use coffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2', '>= 4.2.2'
# Use uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Use turbolinks to make following links in your web application faster
# gem 'turbolinks'
gem 'jquery-turbolinks'
# Use font awesome for icons
gem 'font-awesome-sass'
# Use paperclip for image cropping
gem "paperclip", "~> 5.0.0"
# Use AWS S3 service as storage
gem 'aws-sdk', '~> 2.3.0'
# Use friendlyID for custom profile URLs
gem 'friendly_id', '~> 5.1.0'
# Use cocoon for nested forms
gem 'cocoon', '~> 1.2', '>= 1.2.10'

gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

gem 'ckeditor'

#### Back End Gems

# Use jbuilder to build JSON APIs
gem 'jbuilder', '~> 2.0'
# Use devise for user authentication
gem 'devise', '~> 4.3'
# Use pundit for user authorization
gem 'pundit'
# Use postgreSQL for the database
gem 'pg', '~> 0.21.0'

# A PDF generation plugin for Ruby on Rails
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

gem 'figaro'

gem 'kaminari'


group :doc do
  # bundle exec rake doc:rails to generate the API under doc/api.
  gem 'sdoc', '~> 0.4.0'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-rails'
  gem 'pry-byebug'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'railroady'
  # Use letter opener to preview mail in the browser
  gem 'letter_opener'
  gem 'listen'
end

group :production do
  gem 'sendgrid-ruby'
end

# Access an IRB console on exception pages or by using <%= console %> in views
gem 'web-console', '~> 3.5', '>= 3.5.1', group: :development
