require 'spec_helper_integration'
require 'generators/doorkeeper/sequel/previous_refresh_token_generator'

describe 'Doorkeeper::Sequel::PreviousRefreshTokenGenerator' do
  include GeneratorSpec::TestCase

  tests Doorkeeper::Sequel::PreviousRefreshTokenGenerator
  destination ::File.expand_path('../tmp/dummy', __FILE__)

  describe 'after running the generator' do
    before :each do
      prepare_destination
      run_generator
    end

    it 'creates a migration' do
      assert_migration 'db/migrate/add_previous_refresh_token_to_access_tokens.rb'
    end
  end
end
