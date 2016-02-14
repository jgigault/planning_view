# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'planning_view/version'

Gem::Specification.new do |spec|
  spec.name          = "planning_view"
  spec.version       = PlanningView::VERSION
  spec.authors       = ["Jean-Michel Gigault"]
  spec.email         = ["jgigault@student.42.fr"]

  spec.summary       = %q{Transform your lists into beautiful responsive planning views.}
  spec.description   = %q{Transform your lists into beautiful responsive planning views.}
  spec.homepage      = "http://github.com/jgigault/planning_view"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.2.2'

  spec.add_dependency 'rails', ['>= 3.0', '< 5.0']
  #spec.add_dependency 'activesupport', ['>= 3.0', '< 6.0']
  #spec.add_dependency 'activesupport', ['>= 3.0', '< 6.0']

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  #spec.add_development_dependency "rspec"
end
