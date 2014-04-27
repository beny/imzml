lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'imzml/version'
 
Gem::Specification.new do |s|
  s.name        = "imzml"
  s.version     = ImzML::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ondra Beneš"]
  s.email       = ["ondra.benes@gmail.com"]
  s.homepage    = "https://github.com/beny/imzml"
  s.summary     = "Simple parser for imzML files."
  s.description = "Parser for mass spectrometry imaging standard file format. Gem does not check the validity of the input file."
  s.add_development_dependency "minitest", "~> 5.3"
  s.add_runtime_dependency "ox", "~> 2.0"
  s.add_runtime_dependency "obo", "~> 0.1", ">= 0.1.4"
  s.files        = Dir.glob("{data,lib}/**/*")
  s.require_path = 'lib'
end
