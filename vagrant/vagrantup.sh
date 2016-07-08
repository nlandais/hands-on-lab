#!/bin/sh
vagrant plugin list | grep vagrant-aws >/dev/null && echo "Vagrant-aws plugin already installed" || vagrant plugin install vagrant-aws
vagrant box list | grep dummy >/dev/null && echo "Dummy AWS Vagrant box already present" || vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
vagrant status | grep -e "running (aws)" >/dev/null && vagrant destroy --force
vagrant up --provider=aws
