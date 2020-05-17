# 覆盖方法，让 rails 从当前文件所在路径查找模版
source_paths << __dir__

# 必备 gem

# Use Active Model has_secure_password
gem 'bcrypt'

# 用 .env 管理不同环境下的配置
gem 'dotenv-rails'

gem_group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'
end

gem_group :development do
  gem 'annotate'
  gem 'foreman'
end

# 初始化 .env 文件
copy_file 'template/.env.example', '.env.example'
copy_file 'template/.env.example', '.env'
copy_file 'template/Procfile', 'Procfile'

application do <<-RUBY
  config.generators do |g|
    g.assets false
    g.helper false
  end
  RUBY
end
