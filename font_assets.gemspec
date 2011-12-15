# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "font_assets/version"

Gem::Specification.new do |s|
  s.name        = "font_assets"
  s.version     = FontAssets::VERSION
  s.authors     = ["Eric Allam"]
  s.email       = ["rubymaverick@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Improve font serving in Rails 3.1}
  s.description = %q{Improve font serving in Rails 3.1}

  s.rubyforge_project = "font_assets"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
