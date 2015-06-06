inlcude_recipe 'mno2-base-cookbook'
include_recipe 'supervisor'

package 'nginx'

user 'mno2' do
  action :create
  system true
  gid ['sudo', 'user']
  shell '/usr/bin/fish'
end

user 'www' do
  action :create
  system true
  gid ['user']
  shell '/bin/bash'
end

group 'www' do
  action :create
  members 'www'
end

directory "/mnt/deploy/www" do
    owner 'www'
    group 'www'
    mode 00755
    action :create
    recursive true
    not_if do
        File.directory?('/mnt/deploy/www')
    end
end

deploy_revision 'home.mno2.org' do
    symlink_before_migrate.clear
    create_dirs_before_symlink.clear
    purge_before_symlink.clear
    symlinks.clear
    repo 'https://github.com/MnO2/home.mno2.org.git'
    revision 'HEAD'
    group 'www'
    user 'www'
    deploy_to '/mnt/deploy/'
    action :deploy
    scm_provider Chef::Provider::Git
end
