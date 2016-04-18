module Doorkeeper
  class AccessGrant < Sequel::Model
    set_dataset :oauth_access_grants

    # TODO: migrate mixin
    include AccessGrantMixin
  end
end
