# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fixed_width_parser/version"

Gem::Specification.new do |s|
  s.name        = "fixed_width_parser"
  s.version     = FixedWidthParser::VERSION
  s.authors     = ["C. Jason Harrelson"]
  s.email       = ["jason@lookforwardenterprises.com"]
  s.homepage    = ""
  s.summary     = %q{}
  s.description = %q{}

  s.rubyforge_project = "fixed_width_parser"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  %w(
    gem-dandy
    rspec
  ).each do |development_dependency|
    s.add_development_dependency development_dependency
  end

  # s.add_runtime_dependency "rest-client"
end
