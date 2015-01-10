set :rvm_type, :user
set :rvm_ruby_version, '2.2.0'

set :application,       'rails-bestpractices.com'
set :scm,               :git
set :repo_url,          'git@github.com:xinminlabs/rails-bestpractices.com.git'
set :use_sudo,          false
set :keep_releases,     5

set :user,    'deploy'
set :group,   'deploy'

set :deploy_to, '/home/deploy/sites/rails-bestpractices.xinminlabs.com/production'

namespace :deploy do
  task :update_jekyll do
    on roles(:app) do
      within "#{deploy_to}/current" do
        execute :bundle, "exec jekyll build"
      end
    end
  end
end

after "deploy:symlink:release", "deploy:update_jekyll"
