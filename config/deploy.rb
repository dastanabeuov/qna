# config valid for current version and patch releases of Capistrano
lock "~> 3.15.0"

set :application, "qna"
set :repo_url, "git@github.com:dastanabeuov/qna.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key", "config/private_pub_thin.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "storage"
