#
# Cookbook Name:: rate-limit-proxy
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
execute "clean it" do
    command "apt-get clean -y"
end

execute "update package index" do
    command "apt-get update"
end


node[:circos_utils][:ubuntu_packages].each do |package_name|
    package "#{package_name}"
end

user "ubuntu" do
    shell "/usr/bin/fish"
end


# install aws cli
execute "pip install awscli"


include_recipe 'spf13-vim::default'
