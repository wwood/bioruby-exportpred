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
  gem.name = "bio-exportpred"
  gem.homepage = "http://github.com/wwood/bioruby-exportpred"
  gem.license = "MIT"
  gem.summary = %Q{Wrapper around the ExportPred algorithm for predicting P. falciparum exported proteins}
  gem.description = %Q{Wrapper around the ExportPred algorithm for predicting P. falciparum exported proteins. Requires local install of the program, which is available from http://bioinf.wehi.edu.au/exportpred/}
  gem.email = "donttrustben near gmail.com"
  gem.authors = ["Ben J Woodcroft"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rake/testtask'
Rake::TestTask.new(:test_without_exportpred) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/test_bio-exportpred.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bio-exportpred #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
