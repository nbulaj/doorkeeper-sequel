require 'spec_helper_integration'
require 'generators/doorkeeper/sequel/application_owner_generator'

describe 'Doorkeeper::Sequel::ApplicationOwnerGenerator' do
  include GeneratorSpec::TestCase

  tests Doorkeeper::Sequel::ApplicationOwnerGenerator
  destination ::File.expand_path('../tmp/dummy', __FILE__)

  describe 'after running the generator' do
    before :each do
      prepare_destination
      run_generator
    end

    it 'creates a migration' do
      assert_migration 'db/migrate/add_owner_to_application.rb'
    end
  end
end
