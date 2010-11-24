# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dnif/version"

Gem::Specification.new do |s|
  s.name        = "dnif"
  s.version     = Dnif::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rafael Souza"]
  s.email       = ["me@rafaelss.com"]
  s.homepage    = "http://rubygems.org/gems/dnif"
  s.summary     = %q{dnif is the new find... for sphinx}
  s.description = %q{dnif is a gem to index data using ActiveRecord finders, letting you index your custom methods and not only your table fields}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 3.0.3"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.3"])
      s.add_runtime_dependency(%q<riddle>, [">= 1.1.0"])
      s.add_runtime_dependency(%q<builder>, [">= 2.1.2"])
      s.add_development_dependency(%q<jeweler>, [">= 1.5.0.pre2"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0.beta.20"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 3.0.3"])
      s.add_dependency(%q<activesupport>, [">= 3.0.3"])
      s.add_dependency(%q<riddle>, [">= 1.1.0"])
      s.add_dependency(%q<builder>, [">= 2.1.2"])
      s.add_dependency(%q<jeweler>, [">= 1.5.0.pre2"])
      s.add_dependency(%q<rspec>, [">= 2.0.0.beta.20"])
      s.add_dependency(%q<database_cleaner>, [">= 0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 3.0.3"])
    s.add_dependency(%q<activesupport>, [">= 3.0.3"])
    s.add_dependency(%q<riddle>, [">= 1.1.0"])
    s.add_dependency(%q<builder>, [">= 2.1.2"])
    s.add_dependency(%q<jeweler>, [">= 1.5.0.pre2"])
    s.add_dependency(%q<rspec>, [">= 2.0.0.beta.20"])
    s.add_dependency(%q<database_cleaner>, [">= 0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
  end
end
