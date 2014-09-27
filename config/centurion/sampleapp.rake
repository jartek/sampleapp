namespace :environment do
  task :common do
    set :image, 'jartek/sample'
  end

  desc 'Production environment'
  task :production => :common do
    set_current_environment(:production)
    # env_vars YOUR_ENV: 'production'
    host_port 23235, container_port: 9293
    host '128.199.176.185'
    # host 'docker-server-prod-2.example.com'
    # host_volume '/mnt/volume1', container_volume: '/mnt/volume1'
  end
end
