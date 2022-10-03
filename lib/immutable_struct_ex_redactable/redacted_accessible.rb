# frozen_string_literal: true

module ImmutableStructExRedactable
  module RedactedAccessible
    class << self
      def included(base)
        base.extend ClassModules
      end
    end

    module ClassModules
      def redacted_accessible_module_for(hash:, config:)
        Module.new do
          config.redacted.each do |attr|
            unredacted_attr_method = "unredacted_#{attr}"
            attr_value = hash[attr]
            code = <<~CODE
              def #{unredacted_attr_method}
                "#{hash[attr]}"
              end
              private :#{unredacted_attr_method}
            CODE
            class_eval code
          end
        end
      end
    end
  end
end
