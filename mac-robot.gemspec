# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: mac-robot 0.5.3 ruby lib
# stub: ext/event_dispatcher/extconf.rb ext/util/extconf.rb

Gem::Specification.new do |s|
  s.name = "mac-robot".freeze
  s.version = "0.5.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["youpy".freeze]
  s.date = "2021-12-01"
  s.description = "A Library to Automate User Interactions".freeze
  s.email = "youpy@buycheapviagraonlinenow.com".freeze
  s.extensions = ["ext/event_dispatcher/extconf.rb".freeze, "ext/util/extconf.rb".freeze]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "ext/event_dispatcher/event_dispatcher.h",
    "ext/event_dispatcher/event_dispatcher.m",
    "ext/event_dispatcher/extconf.rb",
    "ext/lib/mkmf.rb",
    "ext/util/extconf.rb",
    "ext/util/util.h",
    "ext/util/util.m",
    "lib/mac-robot.rb",
    "mac-robot.gemspec",
    "spec/mac-robot_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/youpy/mac-robot".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "A Library to Automate User Interactions".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rake>.freeze, ["< 11.0"])
    s.add_development_dependency(%q<json>.freeze, ["~> 2.5.1"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 2.8.0"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<jeweler>.freeze, ["~> 2.3.9"])
  else
    s.add_dependency(%q<rake>.freeze, ["< 11.0"])
    s.add_dependency(%q<json>.freeze, ["~> 2.5.1"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.8.0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<jeweler>.freeze, ["~> 2.3.9"])
  end
end

