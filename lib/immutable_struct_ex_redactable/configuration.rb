# frozen_string_literal: true

# This is the configuration for ImmutableStructExRedactable.
module ImmutableStructExRedactable
  class << self
    attr_reader :configuration

    # Returns the application configuration object.
    #
    # @return [Configuration] the application Configuration object.
    def configure
      self.configuration ||= Configuration.new

      yield(configuration) if block_given?

      configuration
    end

    private

    attr_writer :configuration
  end

  # This class encapsulates the configuration properties for this gem and
  # provides methods and attributes that allow for management of the same.
  class Configuration
    # Gets/sets the fields that should be redacted for this gem.
    #
    # The default is %i[password].
    #
    # @return [Array<Symbol>] an Array of Symbols that should be redacted.
    attr_accessor :redacted

    # Gets/sets the label that should replace redacted field values.
    #
    # The default is "******".
    #
    # @return [String] the label that should replace redacted field values.
    attr_accessor :redacted_label

    # Gets/sets the redacted unsafe switch that determines whether or not
    # redacted field values are retained as private methods named
    # #unredacted_<field> on the struct returned. If this configuration
    # property is true, redacted field values will be retained and
    # accessible as private methods on the struct.
    #
    # The default is false.
    #
    # @return [Bool] the unsafe switch value.
    attr_accessor :redacted_unsafe

    def redacted_unsafe?
      @redacted_unsafe
    end

    # The constructor; calls {#reset}.
    def initialize
      reset
    end

    # Resets the configuration settings to their default values.
    #
    # @return [void]
    def reset
      @redacted = %i[password]
      @redacted_label = '******'
      @redacted_unsafe = false
    end
  end
end
