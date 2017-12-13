namespace :doorkeeper_sequel do
  namespace :generate do
    desc 'Generate main migration file'
    task :migration do
      DoorkeeperSequel::MigrationGenerator.start
    end

    desc 'Generate migration file for Application Owner functionality'
    task :application_owner do
      DoorkeeperSequel::ApplicationOwnerGenerator.start
    end

    desc 'Generate migration file for Previous Refresh Token functionality'
    task :previous_refresh_token do
      DoorkeeperSequel::PreviousRefreshTokenGenerator.start
    end
  end
end
