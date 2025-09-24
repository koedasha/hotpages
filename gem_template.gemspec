# frozen_string_literal: true

require_relative "lib/hotpages/version"

Gem::Specification.new do |spec|
  spec.name = "hotpages"
  spec.version = Hotpages::VERSION
  spec.authors = [ "planeska" ]
  spec.email = [ "221018698+planeska@users.noreply.github.com" ]

  spec.summary = "Static web site authoring with Ruby."
  spec.homepage = "https://github.com/koedasha/hotpages"
  spec.license = "0bsd"
  spec.required_ruby_version = ">= 3.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/koedasha/hotpages"
  spec.metadata["changelog_uri"] = "https://github.com/koedasha/hotpages/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = [ "lib" ]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "erubi", "~> 1.13"
  spec.add_dependency "fast_gettext", "~> 4.1"
  spec.add_dependency "listen", "~> 3.9"
  spec.add_dependency "tilt", "~> 2.6"
  spec.add_dependency "webrick", "~> 1.9"
  spec.add_dependency "zeitwerk", "~> 2.7"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
