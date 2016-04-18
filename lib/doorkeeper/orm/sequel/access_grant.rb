module Doorkeeper
  class AccessGrant < Sequel::Model
    set_dataset :oauth_access_grants

    include AccessGrantMixin
  end
end
