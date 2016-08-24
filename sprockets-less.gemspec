# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sprockets/less/version"

Gem::Specification.new do |s|
  s.name        = "sprockets-less"
  s.version     = Sprockets::Less::VERSION
  s.authors     = ["Loic Nageleisen"]
  s.email       = ["loic.nageleisen@gmail.com"]
  s.homepage    = "http://github.com/lloeki/sprockets-less"
  s.summary     = %q{The dynamic stylesheet language for the Sprockets asset pipeline.}
  s.description = %q{The dynamic stylesheet language for the Sprockets asset pipeline.}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency 'less', '~> 2.4'

  s.add_development_dependency 'sprockets-helpers', '~> 1.0'
  s.add_development_dependency 'yui-compressor'

  s.add_development_dependency 'rspec',             '~> 2.13'
  s.add_development_dependency 'test_construct',    '~> 2.0'
  s.add_development_dependency 'appraisal', '~> 2.1', '>= 2.1'
  s.add_development_dependency 'rake', '>= 10.5', '>= 10.5'
end
