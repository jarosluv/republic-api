source "https://rubygems.org"

gem "rails", "~> 8.0.1"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "solid_cache"
gem "solid_queue"
gem "dry-monads"
gem "bootsnap", require: false
gem "thruster", require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# API
gem "rswag-api", "~> 2.13"
gem "rswag-ui", "~> 2.13"
gem "skooma", "~> 0.3"


group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rspec-rails", require: false
  gem "rubocop-rails-omakase", require: false
end
