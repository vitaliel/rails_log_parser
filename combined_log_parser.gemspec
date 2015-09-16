# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'log_parser/version'

Gem::Specification.new do |s|
  s.name        = 'combined_log_parser'
  s.version     = LogParser::Version.to_s
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Vitalie Lazu']
  s.email       = ['vitalie@assembla.com']
  s.homepage    = 'http://github.com/vitaliel/rails_log_parser'
  s.summary     = 'LogParser - parses rails,http combined logs and export them to csv'
  s.description = %q{It uses regexp to parse rails/http logs, it also has a sample that uses treetop gem, but it is too slow.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.license = 'MIT'

  # s.add_runtime_dependency('highline', ['>= 0'])
  s.add_development_dependency('rspec', ['~> 3.3'])
end
