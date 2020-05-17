# 覆盖方法，让 rails 从当前文件所在路径查找模版
source_paths << __dir__

rails_command 'webpacker:install'

run 'yarn add jquery'
run 'yarn add expose-loader'

run 'mkdir -p app/javascript/images'

gsub_file "app/javascript/packs/application.js", "// const images", "const images"
gsub_file "app/javascript/packs/application.js", "// const imagePath", "const imagePath"

copy_file 'webpacker/template/loaders/jquery.js', 'config/webpack/loaders/jquery.js'
copy_file 'webpacker/template/loaders/ujs.js', 'config/webpack/loaders/ujs.js'

inject_into_file 'config/webpack/environment.js', after: "const { environment } = require('@rails/webpacker')\n" do
<<-CODE
environment.loaders.append('jquery', require('./loaders/jquery'))
environment.loaders.append('ujs', require('./loaders/ujs'))
CODE
end

copy_file '.yarnrc'
