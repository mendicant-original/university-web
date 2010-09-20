# This configuration file works with both the Compass command line tool and within Rails.
# Require any additional compass plugins here.
project_type = :rails
project_path = Compass::AppIntegration::Rails.root
# Set this to the root of your project when deployed:
http_path = "/"

if Compass::AppIntegration::Rails.env == :development
  css_dir = "public/stylesheets/compiled"
else
  css_dir = "tmp/stylesheets" # For Heroku
end

sass_dir = "app/stylesheets"
environment = Compass::AppIntegration::Rails.env
# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true
