# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sudoku_solver/version'

Gem::Specification.new do |spec|
  spec.name          = "sudoku-jedi"
  spec.version       = SudokuSolver::VERSION
  spec.authors       = ["ajn123"]
  spec.email         = ["ajn123@vt.edu"]
  spec.summary       = %q{Solves a sudoku puzzle with a CLI}
  spec.description   = %q{Solves easy to moderate soduku puzzles efficiently}
  spec.homepage      = "https://github.com/RubyQuarry/sudoku-jedi"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "coveralls"
  spec.add_dependency "thor"
end

