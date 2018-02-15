module DoorkeeperSequel
  module SequelCompat
    extend ActiveSupport::Concern

    # ActiveRecord methods used by Doorkeeper outside the ORM.
    # Should be extracted at the architectural level.
    included do
      plugin :active_model

      # Sequel 4.47 and higher deprecated #set_allowed_columns
      if (::Sequel::MAJOR >= 4 && ::Sequel::MINOR >= 47) || ::Sequel::MAJOR >= 5
        plugin :whitelist_security
      end

      self.raise_on_save_failure = false

      def update_attribute(column, value)
        self[column] = value
        save(columns: [column.to_sym], validate: false)
      end

      def update_attributes(*args)
        update(*args)
      end

      def save!(*)
        save(raise_on_failure: true)
      end

      def transaction(opts = {}, &block)
        db.transaction(opts, &block)
      end
    end

    module ClassMethods
      def create!(values = {}, &block)
        new(values, &block).save(raise_on_failure: true)
      end

      def table_exists?
        db.table_exists?(table_name)
      end

      def ordered_by(attribute, direction = :asc)
        order(::Sequel.public_send(direction, attribute))
      end

      # find(1) or find("1") - will work like find(id: 1)
      # find(name: 'John') - will work like find(name: 'John')
      def find(*args, &block)
        if args.first.is_a?(Hash)
          super(*args, &block)
        else
          super(id: args)
        end
      end
    end
  end
end
