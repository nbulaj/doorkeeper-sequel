# frozen_string_literal: true

module Doorkeeper
  module Orm
    module Sequel
      class StaleRecordsCleaner
        def initialize(base_scope)
          @base_scope = base_scope
        end

        def clean_revoked
          @base_scope
            .where(::Sequel.~(revoked_at: nil))
            .where { revoked_at < Time.current }
            .delete
        end

        def clean_expired(ttl)
          @base_scope
            .where { created_at < (Time.current - ttl) }
            .delete
        end
      end
    end
  end
end
