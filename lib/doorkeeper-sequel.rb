require 'doorkeeper-sequel/version'

require 'doorkeeper'

require 'doorkeeper/orm/sequel'

module DoorkeeperSequel
  def load_locales
    locales_dir = File.expand_path('../../config/locales', __FILE__)
    locales = Dir[File.join(locales_dir, '*.yml')]

    I18n.load_path |= locales
  end

  module_function :load_locales
end

DoorkeeperSequel.load_locales
