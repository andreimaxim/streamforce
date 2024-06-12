# frozen_string_literal: true

require_relative "lib/streamforce/version"

Gem::Specification.new do |spec|
  spec.name = "streamforce"
  spec.version = Streamforce::VERSION
  spec.authors = ["Andrei Maxim"]
  spec.email = ["andrei@andreimaxim.ro"]

  spec.summary = "Small wrapper over the Salesforce Streaming API"
  spec.homepage = "https://github.com/andreimaxim/streamforce"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage 
  spec.metadata["changelog_uri"] = "https://github.com/andreimaxim/streamforce/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "base64"
  spec.add_dependency "zeitwerk"
  spec.add_dependency "faye"
  spec.add_dependency "relaxed_cookiejar"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
