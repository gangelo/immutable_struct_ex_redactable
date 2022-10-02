# frozen_string_literal: true

require 'immutable_struct_ex'
require_relative 'immutable_struct_ex_redactable/configuration'
require_relative 'immutable_struct_ex_redactable/version'

module ImmutableStructExRedactable
  module_function

  def create(**hash, &block)
    config = ImmutableStructExRedactable.configure
    create_with(config, **hash, &block)
  end

  def create_with(config, **hash, &block)
    config.redacted.each do |attr|
      next unless hash.key? attr

      hash[attr] = config.redacted_label
    end

    ImmutableStructEx.new(**hash, &block)
  end
end
