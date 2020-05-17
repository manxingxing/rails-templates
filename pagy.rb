gem 'pagy'
run 'bundle'

initializer 'pagy.rb', <<-CODE
require 'pagy/extras/bootstrap'
Pagy::VARS[:items] = 25
CODE

git add: '.'
git commit: '-m "安装 pagy gem"'

