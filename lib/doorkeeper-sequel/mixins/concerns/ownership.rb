# frozen_string_literal: true

module DoorkeeperSequel
  module Ownership
    extend ActiveSupport::Concern

    included do
      plugin :polymorphic

      many_to_one :owner, polymorphic: true

      def validate_owner?
        Doorkeeper.configuration.confirm_application_owner?
      end
    end
  end
end
