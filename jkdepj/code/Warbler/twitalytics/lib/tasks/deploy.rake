# START:require
require 'bundler'
Bundler.require(:deploy)
# END:require

# START:with_ssh
SSH_KEY = "~/.vagrant.d/insecure_private_key"

def with_ssh
  Net::SSH.start("localhost", "vagrant", {
     :port => 2222, :keys => [SSH_KEY] 
  }) do |ssh|
    yield ssh
  end
end
# END:with_ssh

# START:scp_upload
def scp_upload(local_file, remote_file)
  Net::SCP.upload!("localhost", "vagrant", local_file, remote_file, {
      :ssh => {:port => 2222, :keys => [SSH_KEY]}
  }) do |ch, name, sent, total|
    print "\rCopying #{name}: #{sent}/#{total}"
  end; print "\n"
end
# END:scp_upload

#START:deploy
namespace :deploy do
  desc "Package the application into a WAR file and deploy it"
  task :war do
    Warbler::Task.new(:warble)
    Rake::Task['warble'].invoke
    # END:deploy
    # START:prepare
    with_ssh do |ssh|
      ssh.exec! "mkdir -p deploy/"
      ssh.exec! "rm -rf deploy/*"
    end
    # END:prepare

    # START:scp_war
    scp_upload("twitalytics.war", "deploy/")
    # END:scp_war

    # START:migrate
    with_ssh do |ssh|
      ssh.exec <<-SH do |ch, stream, data|
        cd deploy
        export PATH=$PATH:/opt/jruby/bin
        export RAILS_ENV=production
        sudo /opt/jruby/bin/jgem install warbler-exec
        jruby -S warbler-exec twitalytics.war bin/rake db:migrate
      SH
        print data
      end
    end
    # END:migrate

    # START:deploy_tomcat
    with_ssh do |ssh|
      ssh.exec! "sudo mv deploy/twitalytics.war /var/lib/tomcat6/webapps/"
      puts 'Deployment complete!'
    end
    # END:deploy_tomcat
    # START:deploy
  end
end
# END:deploy
