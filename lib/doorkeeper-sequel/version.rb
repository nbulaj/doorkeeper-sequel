# frozen_string_literal: true

require_relative "gem_version"

module DoorkeeperSequel
  def self.version
    gem_version
  end
end
