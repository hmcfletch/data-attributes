# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "data-attributes/version"

Gem::Specification.new do |s|
  s.name        = "data-attributes"
  s.version     = DataAttributes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Les Fletcher"]
  s.email       = ["les.fletcher@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A gem for easy access to attributes stored in a serialized data hash}
  s.description = %q{A gem for easy access to attributes stored in a serialized data hash}

  s.rubyforge_project = "data-attributes"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
