module Doorkeeper
  module Orm
    module Sequel
      module Models
        module SequelCompat
          extend ActiveSupport::Concern

          included do
            plugin :active_model

            def update_attribute(column, value)
              self[column] = value
              save(columns: [column.to_sym], validate: false)
            end

            def update_attributes(*args)
              update(*args)
            end

            def self.create!(values = {}, &block)
              new(values, &block).save(raise_on_failure: true)
            end

            def transaction(opts = {}, &block)
              db.transaction(opts, &block)
            end
          end
        end
      end
    end
  end
end
