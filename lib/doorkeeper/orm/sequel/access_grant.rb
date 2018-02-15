module Doorkeeper
  class AccessGrant < Sequel::Model(:oauth_access_grants)
    include DoorkeeperSequel::AccessGrantMixin
  end
end
