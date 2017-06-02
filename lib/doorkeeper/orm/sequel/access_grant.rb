require_relative 'models/access_grant_mixin'

module Doorkeeper
  class AccessGrant < Sequel::Model(:oauth_access_grants)
    include Doorkeeper::Orm::Sequel::AccessGrantMixin
  end
end
