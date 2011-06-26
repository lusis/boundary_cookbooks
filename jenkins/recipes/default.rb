#
# Author:: Joe Williams (<j@boundary.com>)
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2011, Boundary
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
case node.platform
when "redhat","centos","fedora"
  include_recipe "yum"

  yum_key "jenkins" do
    key "http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key"
  end

  yum_repo "jenkins" do
    name "Jenkins YUM Repo"
    url "http://pkg.jenkins-ci.org/redhat/"
    action :add
  end

when "debian","ubuntu"
  include_recipe "apt"

  apt_repository "jenkins" do
    uri "http://pkg.jenkins-ci.org/debian"
    components ["binary/"]
    key "http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key"
    action :add
  end

else
  Chef::Log.fatal!("I don't support #{node.platform} yet")
end

package "jenkins"
package "curl"

service "jenkins" do
  supports :status => true, :restart => true
  action [ :start, :enable ]
end

remote_file "/var/lib/jenkins/.initial_jenkins_update.json" do
  source "http://updates.jenkins-ci.org/update-center.json"
  notifies :run, "execute[bootstrap_plugins_list]", :immediately
end

execute "bootstrap_plugins_list" do
  command "sed '1d;$d' .initial_jenkins_update.json > .default.json;curl -X POST -H 'Accept: application/json' -d @.default.json http://localhost:8080/updateCenter/byId/default/postBack --verbose"
  cwd "/var/lib/jenkins/"
  action :nothing
end

unless node["jenkins"]["plugins"].size == 0
  node["jenkins"]["plugins"].each do |plug|
    jenkins "#{plug}" do
      action :install_plugin
      cli_jar node["jenkins"]["clijar"]
      url "http://localhost:8080"
      path "/var/lib/jenkins"
      notifies :restart, "service[jenkins]"
    end
  end
end
