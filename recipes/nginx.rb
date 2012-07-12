
include_recipe "nginx::default"

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

service "nginx" do
  action :start
end

