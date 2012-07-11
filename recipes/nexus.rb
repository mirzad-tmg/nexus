#
# Cookbook Name:: nexus
# Recipe:: default
#
#http://www.sonatype.org/downloads/nexus-2.0.6-bundle.tar.gz
#The issue here is this url changes.  When a new version of nexus is made available,
#this particular version will get retired to <url>/older/<version>.gz.
#we should host our own versions we install on/in some web enabled location.

nexusversion = "2.0.6"
nexusdirname = "nexus-#{nexusversion}"
nexustarname = "#{nexusdirname}-bundle.tar.gz"

#I got the checksum by downloading the tar, then running sha256sum against it.
remote_file "/tmp/#{nexustarname}" do
  source "http://www.sonatype.org/downloads/#{nexustarname}"
  #mode "0644"
  checksum "b329d2b0b4b8e532211ff2ca10539ccef929e63c8ee499630cc26c9734b6b4c1" # A SHA256 (or portion thereof) of the file.
end

#sudo delgroup nexus
group "nexus" do
  group_name "nexus"
  not_if "groups nexus"
end

#sudo deluser nexus
user "nexus" do
  comment "Nexus User"
  gid "nexus"
  not_if "id nexus"
end

execute "tar" do
 installation_dir = "/usr/local"
 cwd installation_dir
 command "tar zxf /tmp/#{nexustarname}"
 action :run
 not_if "test -f /usr/local/#{nexusdirname}"
end

execute "chown" do
 command "chown -R nexus /usr/local/#{nexusdirname} && chown -R nexus /usr/local/sonatype-work"
 action :run
end

execute "chgrp" do
 command "chgrp -R nexus /usr/local/#{nexusdirname} && chgrp -R nexus /usr/local/sonatype-work"
 action :run
end

link "/usr/local/nexus" do
  to "/usr/local/#{nexusdirname}"
  not_if "test -f /usr/local/nexus"
end

template "/etc/init.d/nexus" do
  source "nexus/nexus.erb"
  mode "0755"
end

template "/usr/local/sonatype-work/nexus/conf/logback.properties" do
  source "nexus/logback.properties.erb"
end

directory "/var/log/nexus" do
  owner "nexus"
  group "nexus"
  action :create
end

#sudo update-rc.d -f nexus remove
#sudo rm /etc/init.d/nexus
#make sure nexus is part of the standard stop/start statuses
execute "update-rc" do
   command "update-rc.d nexus defaults"
   action :run
end

service "nexus" do
  action :start
end
