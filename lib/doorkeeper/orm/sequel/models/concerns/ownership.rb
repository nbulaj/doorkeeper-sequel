module Doorkeeper
  module Orm
    module Sequel
      module Ownership
        extend ActiveSupport::Concern

        included do
          plugin :polymorphic

          many_to_one :owner, polymorphic: true

          def validate
            super

            validates_presence [:owner_id] if validate_owner?
          end
        end

        def validate_owner?
          Doorkeeper.configuration.confirm_application_owner?
        end
      end
    end
  end
end
