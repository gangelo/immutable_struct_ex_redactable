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
        unredacted_method_proc = method(:unredacted_attr_method)
        Module.new do
          if config.whitelist.any?
            hash.each_key do |attr|
              next if config.whitelist.include? attr

              class_eval unredacted_method_proc.call(attr: attr, hash: hash)
            end
          else
            config.blacklist.each do |attr|
              class_eval unredacted_method_proc.call(attr: attr, hash: hash)
            end
          end
        end
      end

      def unredacted_attr_method(attr:, hash:)
        unredacted_attr_method = "unredacted_#{attr}"
        <<~CODE
          def #{unredacted_attr_method}
            "#{hash[attr]}"
          end
          private :#{unredacted_attr_method}
        CODE
      end
    end
  end
end
