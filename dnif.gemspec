# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dnif}
  s.version = "0.0.1.alpha.2"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rafael Souza"]
  s.date = %q{2010-07-01}
  s.description = %q{dnif is a gem to index data using ActiveRecord finders, letting you index your custom methods and not only your table fields}
  s.email = %q{me@rafaelss.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "README.rdoc",
     "Rakefile",
     "dnif.gemspec",
     "lib/dnif.rb",
     "lib/dnif/configuration.rb",
     "lib/dnif/index_builder.rb",
     "lib/dnif/indexer.rb",
     "lib/dnif/multi_attribute.rb",
     "lib/dnif/search.rb",
     "lib/dnif/tasks.rb",
     "test/fixtures/db/schema.rb",
     "test/fixtures/log/searchd.pid",
     "test/fixtures/models.rb",
     "test/fixtures/templates/config.erb",
     "test/test_helper.rb",
     "test/unit/test_configuration.rb",
     "test/unit/test_dnif.rb",
     "test/unit/test_index_builder.rb",
     "test/unit/test_indexer.rb",
     "test/unit/test_multi_attribute.rb",
     "test/unit/test_search.rb"
  ]
  s.homepage = %q{http://github.com/rafaelss/dnif}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{dnif is the new find... for sphinx}
  s.test_files = [
    "test/fixtures/db/schema.rb",
     "test/fixtures/models.rb",
     "test/test_helper.rb",
     "test/unit/test_configuration.rb",
     "test/unit/test_dnif.rb",
     "test/unit/test_index_builder.rb",
     "test/unit/test_indexer.rb",
     "test/unit/test_multi_attribute.rb",
     "test/unit/test_search.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<riddle>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<riddle>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<riddle>, [">= 0"])
  end
end

