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
