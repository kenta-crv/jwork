# -*- encoding: utf-8 -*-
# stub: wysiwyg-rails 4.0.10 ruby lib

Gem::Specification.new do |s|
  s.name = "wysiwyg-rails".freeze
  s.version = "4.0.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Froala Labs".freeze]
  s.date = "2022-03-15"
  s.description = "A beautiful WYSIWYG HTML text editor. High performance and modern design make it easy to use for developers and loved by users.".freeze
  s.email = ["stefan@froala.com".freeze]
  s.homepage = "https://github.com/froala/wysiwyg-rails".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.3.23".freeze
  s.summary = "an asset gemification of the Froala WYSIWYG Editor library".freeze

  s.installed_by_version = "3.3.23" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<railties>.freeze, [">= 3.2.7", "< 7.0"])
  else
    s.add_dependency(%q<railties>.freeze, [">= 3.2.7", "< 7.0"])
  end
end
