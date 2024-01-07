# frozen_string_literal: true

require_relative 'lib/immutable_struct_ex_redactable/version'

Gem::Specification.new do |spec|
  spec.name = 'immutable_struct_ex_redactable'
  spec.version = ImmutableStructExRedactable::VERSION
  spec.authors      = ['Gene M. Angelo, Jr.']
  spec.email        = ['public.gma@gmail.com']

  spec.summary = 'The redactable version of the immutable_stuct_ex gem.'
  spec.description = 'Creates and initializes an immutable struct in one step and provides redaction functionality.'
  spec.homepage = 'https://github.com/gangelo/immutable_struct_ex_redactable'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.0.1', '< 4.0')

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/gangelo/immutable_struct_ex_redactable/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'immutable_struct_ex', '~> 1.0', '>= 1.0.5'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.post_install_message = <<~POST_INSTALL
    Thank you for installing immutable_struct_ex_redactable.

    immutable_struct_ex_redactable now supports `ImmutableStructExRedactable::Configuration#whitelist`
    See the README.md for more information.

    Please note that `ImmutableStructExRedactable::Configuration#redacted` will be deprecated in a future release.
    Please use `ImmutableStructExRedactable::Configuration#blacklist` instead.
  POST_INSTALL
end
