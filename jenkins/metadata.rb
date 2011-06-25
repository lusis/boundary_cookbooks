maintainer        "Boundary"
maintainer_email  "ops@boundary.com"
license           "Apache 2.0"
description       "Installs jenkins"
version           "0.2"
%w{redhat debian ubuntu centos fedora}.each do |distro|
  supports "#{distro}"
end
%w{apt yum}.each do |cb|
  depends "#{cb}"
end
