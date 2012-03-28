# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "mac-robot"
  gem.homepage = "http://github.com/youpy/mac-robot"
  gem.license = "MIT"
  gem.summary = %Q{A Library to Automate User Interactions}
  gem.description = %Q{A Library to Automate User Interactions}
  gem.email = "youpy@buycheapviagraonlinenow.com"
  gem.authors = ["youpy"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

# rule to build the extension: this says
# that the extension should be rebuilt
# after any change to the files in ext
ext_names = %w/event_dispatcher/
ext_names.each do |ext_name|
  file "lib/#{ext_name}.bundle" =>
    Dir.glob("ext/#{ext_name}/*{.rb,.m}") do
    Dir.chdir("ext/#{ext_name}") do
      # this does essentially the same thing
      # as what RubyGems does
      ruby "extconf.rb"
      sh "make"
    end
    cp "ext/#{ext_name}/#{ext_name}.bundle", "lib/"
  end

  task :spec => "lib/#{ext_name}.bundle"
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec
