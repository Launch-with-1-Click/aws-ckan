# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "chef/ubuntu-13.10"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :private_network, ip: "192.168.33.10"

  config.vm.provider :aws do |aws, override|
    override.vm.box = "dummy"
    override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

    aws.access_key_id     = ENV['AWS_ACCESS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name      = ENV['AWS_EC2_KEYPAIR']

    aws.region = "us-east-1"
    aws.ami = "ami-35dbde5c" # Ubuntu13.10 64bit

    aws.instance_type = "t1.micro"

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = ENV['AWS_EC2_KEYPAIR_PATH']
  end

  config.vm.provision :shell, :path => "bootstrap.sh"
end
