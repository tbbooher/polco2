module Mongoid
  module CounterCache
    extend ActiveSupport::Concern

    module ClassMethods
      def counter_cache(options)
        name = options[:name]
        counter_field = options[:field]

        after_create do |document|
          relation = document.send(name)
          if relation
            relation.inc(counter_field.to_sym, 1) if relation.class.fields.keys.include?(counter_field)
          end
        end

        after_destroy do |document|
          relation = document.send(name)
          if relation && relation.class.fields.keys.include?(counter_field)
            relation.inc(counter_field.to_sym, -1)
          end
        end
      end
    end

  end
end