#encoding: utf-8

Gem::Specification.new do |s|
  s.name    = "sinatra-content-for2"
  s.version = "0.2.4"
  s.date    = "2011-02-04"

  s.description = "Small Sinatra extension to add a content_for helper similar to Rails'"
  s.summary     = "Small Sinatra extension to add a content_for helper similar to Rails'"
  s.homepage    = "https://github.com/Undev/sinatra-content-for2"

  s.authors = ["Nicolás Sanguinetti"]
  s.email   = "contacto@nicolassanguinetti.info"

  s.require_paths     = ["lib"]
  s.rubyforge_project = "sinatra-ditties"
  s.has_rdoc          = true
  s.rubygems_version  = "1.3.7"

  s.add_dependency "sinatra"

  if s.respond_to?(:add_development_dependency)
    s.add_development_dependency "contest"
    s.add_development_dependency "sr-mg"
    s.add_development_dependency "redgreen"
  end

  s.files = %w[
.gitignore
LICENSE
README.rdoc
sinatra-content-for2.gemspec
lib/sinatra/content_for2.rb
test/content_for_test.rb
]
end

