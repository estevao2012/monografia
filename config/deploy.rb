# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'segmentacao_rodovias'
set :repo_url, 'git@github.com:estevao2012/api-segmentacao-rodovias.git'

# setup rbenv.
set :rbenv_type, :system
set :rbenv_ruby, '2.1.3'
set :rbenv_path, '/home/ubuntu/.rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

set :keep_releases, 5

# set :linked_files, %w{config/database.yml}

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do
  # after :finishing, 'deploy:cleanup'
end
