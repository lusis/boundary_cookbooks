default["jenkins"]["plugins"] = ["backup", "audit-trail"]
case node.platform
when "redhat","centos","ubuntu"
  default["jenkins"]["clijar"] = "/var/lib/jenkins/war/WEB-INF/jenkins-cli.jar"
when "ubuntu","debian"
  default["jenkins"]["clijar"] = "/var/run/jenkins/war/WEB-INF/jenkins-cli.jar"
end
