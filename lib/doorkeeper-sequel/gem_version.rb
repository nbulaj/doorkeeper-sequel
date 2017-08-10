module DoorkeeperSequel
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 1
    MINOR = 2
    TINY  = 3

    STRING = [MAJOR, MINOR, TINY].compact.join('.')
  end
end
