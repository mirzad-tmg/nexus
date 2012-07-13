
include_recipe "nginx::default"

#Depending on if SSL has been selected, we should expand/uncomment the ssl configuration bits.
#or maybe the ssl enablement should happen in an entirely different file.
template "/etc/nginx/sites-available/nexus" do
  source "nginx/nexus.site.erb"
  mode "0755"
end


link "/etc/nginx/sites-enabled/nexus" do
  to "/etc/nginx/sites-available/nexus"
  not_if "test -f /etc/nginx/sites-enabled/nexus"
end
#this seems like a pretty ghetto way to do this.  I'd think that during 
#initial gninx setup, there should be some options to establish the default
#site.  Does anyone want that?
link "/etc/nginx/sites-enabled/default" do
  action :delete
  only_if "test -L /etc/nginx/sites-enabled/default"
end

link "/etc/nginx/sites-enabled/000-default" do
  action :delete
  only_if "test -L /etc/nginx/sites-enabled/000-default"
end

secret = Chef::EncryptedDataBagItem.load_secret("/etc/chef/databag_key")
encrypted_certs = Chef::EncryptedDataBagItem.load("encrypted_certs", "nexus_nginx", secret)
key = encrypted_certs["key"]
cert = encrypted_certs["cert"]
#Chef::Log.info("here is the encrypted stuff  - \"#{key}\"")

#this portion should be wrapped up in an "if"
file "/etc/nginx/certs/es.cert" do
  mode "0755"
  content "#{cert}"
  action :create
end
file "/etc/nginx/certs/es.key" do
  mode "0755"
  content "#{key}"
  action :create
end
####

service "nginx" do
  action :start
end

