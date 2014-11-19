# vi: set ft=ruby :

def cache config, name, path
  require 'fileutils'
  require 'pathname'
  name = name.to_s
  local = File.join(File.expand_path('~/.vagrant.d/cache'), config.vm.box, name)
  FileUtils.mkdir_p local
  config.vm.synced_folder local, path
end

Vagrant.configure('2') do |config|
  config.vm.define('ains') do |app|
    app.vm.box = 'ubuntu/trusty64'
    app.windows.set_work_network = true

    app.vm.provider 'virtualbox' do |v|
      v.memory = 1024
      v.name = 'ains'
    end

    cache app, :apt, '/var/cache/apt/archives'
    cache app, :chef, '/var/chef/cache'
    cache app, :gem, '/var/lib/gems/2.1.0/cache'

    app.vm.network :forwarded_port, guest: 4567, host: 4567

    app.vm.synced_folder '.', '/vagrant', disabled: true
    app.vm.synced_folder '.', '/home/vagrant/ainsleytwo'

    app.vm.provision :shell, path: 'provision_script.sh'
  end
end
