module DoorkeeperSequel
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 1
    MINOR = 5
    TINY  = 0

    STRING = [MAJOR, MINOR, TINY].compact.join('.')
  end
end
