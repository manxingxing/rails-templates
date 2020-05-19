gem 'pagy'
run 'bundle'

initializer 'pagy.rb', <<-CODE
require 'pagy/extras/bootstrap'
Pagy::VARS[:items] = 25
CODE
