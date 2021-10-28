Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "localhost"
  config.vm.synced_folder "D:/Vagrant/projects/web", "/var/www"
  config.vm.synced_folder "D:/Vagrant/projects/apache2", "/etc/apache2"
  config.vm.network :forwarded_port, guest: 80, host: 4583, protocol: "tcp"
  config.vm.network :forwarded_port, guest: 443, host: 4584, protocol: "tcp"
  config.vm.network :private_network, ip: "10.0.1.10"
  config.vm.provision :shell, path: "config.sh"
end