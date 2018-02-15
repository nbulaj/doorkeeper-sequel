class User < Sequel::Model
  include DoorkeeperSequel::SequelCompat

  class << self
    def authenticate!(name, password)
      User.where(name: name, password: password).first
    end

    def create!(values = {}, &block)
      new(values, &block).save(raise_on_failure: true)
    end
  end
end
