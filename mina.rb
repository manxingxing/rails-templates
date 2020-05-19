gem 'mina', require: false
gem 'mina-multistage', require: false

run 'bundle install'
run 'bundle exec mina init'

inject_into_file 'config/deploy.rb', after: /^require 'mina\/rails'/ do
  "\nrequire 'mina/multistage'"
end
run 'bundle exec mina multistage:init'

uncomment_lines 'config/deploy.rb', 'mina/rvm'
inject_into_file 'config/deploy.rb', after: /set :shared_files.*/ do
  "\nset :asset_dirs, fetch(:asset_dirs, []).push('app/javascript')"
end

inject_into_file 'config/deploy.rb', after: /fetch\(:shared_dirs, \[\]\).push\(/ do
  "'public/packs', 'node_modules', 'tmp/pids', 'tmp/sockets'"
end

inject_into_file 'config/deploy.rb', after: /fetch\(:shared_files, \[\]\).push\(/ do
  "'.env'"
end
