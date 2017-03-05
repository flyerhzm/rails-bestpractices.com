role :web,  'rails-bestpractices.com'
role :app,  'rails-bestpractices.com'

server 'rails-bestpractices.com', user: 'deploy', roles: %w{web app}, port: 12222
