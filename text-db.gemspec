# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'textdb/version'

Gem::Specification.new do |spec|
  spec.name          = "text-db"
  spec.version       = Textdb::VERSION
  spec.authors       = ["Ondřej Moravčík"]
  spec.email         = ["moravcik.ondrej@gmail.com"]
  spec.description   = %q{Textdb is a database which structure is determined by folders and data are represented by files.}
  spec.summary       = %q{}
  spec.homepage      = "https://github.com/ondra-m/textdb"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
