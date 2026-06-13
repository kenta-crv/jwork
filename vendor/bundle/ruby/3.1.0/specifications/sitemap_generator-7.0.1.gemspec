# -*- encoding: utf-8 -*-
# stub: sitemap_generator 7.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "sitemap_generator".freeze
  s.version = "7.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Karl Varga".freeze]
  s.date = "2026-04-28"
  s.description = "SitemapGenerator is a framework-agnostic XML Sitemap generator written in Ruby with automatic Rails integration.  It supports Video, News, Image, Mobile, PageMap and Alternate Links sitemap extensions and includes Rake tasks for managing your sitemaps, as well as many other great features.".freeze
  s.email = "kjvarga@gmail.com".freeze
  s.homepage = "https://github.com/kjvarga/sitemap_generator".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.3.27".freeze
  s.summary = "Easily generate XML Sitemaps".freeze

  s.installed_by_version = "3.3.27" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<builder>.freeze, ["~> 3.0"])
  else
    s.add_dependency(%q<builder>.freeze, ["~> 3.0"])
  end
end
