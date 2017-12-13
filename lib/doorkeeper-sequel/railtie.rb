module DoorkeeperSequel
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load File.expand_path('../tasks/doorkeeper-sequel.rake', __FILE__)
    end
  end
end
