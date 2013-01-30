# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sync-em/version'

Gem::Specification.new do |gem|
  gem.name          = "sync-em-pg"
  gem.version       = Sync::Em::Pg::VERSION
  gem.authors       = ["Petr Yanovich"]
  gem.email         = ["fl00r@yandex.ru"]
  gem.description   = %q{em-pg on fibers}
  gem.summary       = %q{em-pg on fibers}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "em-synchrony"
  gem.add_dependency "pg"
  gem.add_dependency "em-pg"
end
