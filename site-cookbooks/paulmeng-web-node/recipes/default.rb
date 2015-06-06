user 'mno2' do
  action :create
  system true
  home '/home/mno2'
  shell '/usr/bin/fish'
end

package 'nginx'

group 'sudo' do
  action :modify
  members 'mno2'
  append true
end

include_recipe 'mno2-base-cookbook'
include_recipe 'supervisor'


directory "/mnt/deploy/www" do
    owner 'www-data'
    group 'www-data'
    mode 00755
    action :create
    recursive true
    not_if do
        File.directory?('/mnt/deploy/www-data')
    end
end

deploy_revision 'home.mno2.org' do
    symlink_before_migrate.clear
    create_dirs_before_symlink.clear
    purge_before_symlink.clear
    symlinks.clear
    repo 'https://github.com/MnO2/home.mno2.org.git'
    revision 'HEAD'
    group 'www-data'
    user 'www-data'
    deploy_to '/mnt/deploy/www-data'
    action :deploy
    scm_provider Chef::Provider::Git
end
