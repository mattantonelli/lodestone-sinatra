lock "~> 3.11.0"

set :application, 'lodestone'
set :repo_url,    'https://github.com/mattantonelli/lodestone'
set :branch,      ENV['BRANCH_NAME'] || 'master'
set :deploy_to,   '/var/sinatra/lodestone'
set :default_env, { path: '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH' }

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.4.1'

namespace :deploy do
  desc 'Symlink database configuration and secret key'
  after :updating, :symlink_config do
    on roles(:app) do
      execute :ln, '-s', shared_path.join('webhook.yml'), release_path.join('config/webhook.yml')
      execute :ln, '-s', shared_path.join('hosts.yml'), release_path.join('config/hosts.yml')
    end
  end

  desc 'Restart application'
  after :publishing, :restart do
    on roles(:app) do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
end
