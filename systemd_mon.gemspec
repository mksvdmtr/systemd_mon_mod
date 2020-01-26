# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'systemd_mon/version'

Gem::Specification.new do |spec|
  spec.name          = "systemd_mon_mod"
  spec.version       = SystemdMon::VERSION
  spec.authors       = ["Jon Cairns", "Dmitriy Maksakov"]
  spec.email         = ["jon@joncairns.com", "mksvdmtr@yandex.ru"]
  spec.summary       = %q{Monitor systemd units and trigger alerts for failed states (Mod for mattermost @channel mentioning)}
  spec.description   = %q{Monitor systemd units and trigger alerts for failed states (Mod for mattermost @channel mentioning)}
  spec.homepage      = "https://github.com/mksvdmtr/systemd_mon_mod"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ruby-dbus", "~> 0.11.0"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
