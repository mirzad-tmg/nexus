
include_recipe "nginx::default"

template "/etc/nginx/sites-available/nexus" do
  source "nginx/nexus.site.erb"
  mode "0755"
end


link "/etc/nginx/sites-enabled/nexus" do
  to "/etc/nginxi/sites-available/nexus"
  not_if "test -f /etc/nginx/sites-enabled/nexus"
end
