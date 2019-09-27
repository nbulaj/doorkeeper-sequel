# frozen_string_literal: true

module DoorkeeperSequel
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load File.expand_path("tasks/doorkeeper-sequel.rake", __dir__)
    end
  end
end
