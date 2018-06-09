# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.5.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# SERVER
# ======
# Add Foreman to read the Procfile
gem 'foreman'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Allow AJAX requests for the frontend app
gem 'rack-cors'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use Sidekiq for your workers
gem 'sidekiq'
# Use symbols and keyword arguments with Sidekiq
gem 'sidekiq-symbols'
# Use Puma as the app server
gem 'puma'

# AUTHENTICATION
# ==============
# Ability management
gem 'cancancan'
# Use devise for authentication
gem 'devise', github: 'plataformatec/devise'
# Token authentication with session objects
gem 'devise_sessionable', github: 'Papercloud/devise_sessionable'
# Authenticate with tokens
gem 'devise_token_auth',  '~> 0.1'

# API
# ===
# Serialize and de-serialize JSON:API
gem 'active_model_serializers', '~> 0.10.0'
# JSON:API pagination
gem 'kaminari'
# Make JSON responses simple
gem 'responders', '~> 2.4'
# JSON:API error rendering
gem 'renderror', github: 'Papercloud/renderror'

# MISC
# ====
# Conditional counter caches
gem 'counter_culture', '~> 1.9'
# Use MJML for email templates
gem 'mjml-rails'
# Form objects
gem 'reform-rails'
# Model validation
gem 'dry-validation', '~> 0.11'
# Error logging
gem 'sentry-raven'

group :development, :test, :staging do
  # Factory Bot to create objects for your tests
  gem 'factory_bot_rails'
  # Generate better fake data
  gem 'faker', github: 'stympy/faker'
  # Freeze and move through time
  gem 'timecop'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Use annotate gem to annotate model.rb files with attributes
  gem 'annotate', github: 'ctran/annotate_models'
  # Open emails in browser rather than sending them
  gem 'letter_opener'
  # Manage environment variables
  gem 'dotenv-rails'

  # TESTING
  # =======
  # Clean the database after testing
  gem 'database_cleaner'
  # use rspec for BDD (behaviour-driven development)
  gem 'rspec-rails'
  # Spring and rspec playing nicely together
  gem 'spring-commands-rspec'

  # DEBUGGING
  # =========
  # Use pry in the console
  gem 'pry-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Make sure we're following best practices
  gem 'rubocop'
  # Helps us to make our code faster
  gem 'fasterer'
  # Checks for security vulnerabilities 
  gem 'brakeman'
  # Auto-run linters when committing changes
  gem 'overcommit'
end

group :test do
  gem 'shoulda-matchers', '~> 3.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
