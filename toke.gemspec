$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "toke/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "toke"
  s.version     = Toke::VERSION
  s.authors     = ["Jack Flannery"]
  s.email       = ["jmflannery81@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "Toke is a simple token authentication solution designed for a rails api."
  s.description = "Toke is a rails engine that can be used in a rails api to provide simple token authentication." 

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "bcrypt-ruby", "~> 3.0.0"

  s.add_development_dependency "pg"

  s.add_development_dependency "minitest-rails"
  s.add_development_dependency "rack-test"
end
