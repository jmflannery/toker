$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "toker/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "toker"
  s.version     = Toker::VERSION
  s.license     = 'MIT'
  s.authors     = ["Jack Flannery"]
  s.email       = ["jack@grandtoursoftware.com"]
  s.homepage    = "https://github.com/jmflannery/toke"
  s.summary     = "Toke is a simple token authentication solution designed for a rails api."
  s.description = "Toke is a rails engine that can be used in a rails api to provide simple token authentication." 

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"
  s.add_dependency "bcrypt-ruby"
  s.add_dependency "active_model_serializers"
  s.add_dependency "jwt"

  s.add_development_dependency "pg"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "factory_girl_rails"
end
