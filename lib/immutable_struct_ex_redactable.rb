# frozen_string_literal: true

require 'immutable_struct_ex'
require_relative 'immutable_struct_ex_redactable/configuration'
require_relative 'immutable_struct_ex_redactable/redacted_accessible'
require_relative 'immutable_struct_ex_redactable/version'

module ImmutableStructExRedactable
  include RedactedAccessible

  module_function

  def create(...)
    config = ImmutableStructExRedactable.configure
    create_with(config, ...)
  end

  def create_with(config, **hash, &block)
    if config.redacted_unsafe?
      redacted_private_accessible_module =
        redacted_accessible_module_for(hash: hash, config: config)
    end

    if config.whitelist.any?
      hash.each_key do |key|
        next if config.whitelist.include? key

        hash[key] = config.redacted_label
      end
    else
      config.blacklist.each do |attr|
        next unless hash.key? attr

        hash[attr] = config.redacted_label
      end
    end

    ImmutableStructEx.new(**hash, &block).tap do |struct|
      struct.extend(redacted_private_accessible_module) if config.redacted_unsafe?
    end
  end
end
