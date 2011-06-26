default["jenkins"]["plugins"] = ["git", "backup", "audit-trail"]
case node.platform
when "redhat","centos","fedora"
  default["jenkins"]["clijar"] = "/var/lib/jenkins/war/WEB-INF/jenkins-cli.jar"
when "ubuntu","debian"
  default["jenkins"]["clijar"] = "/var/run/jenkins/war/WEB-INF/jenkins-cli.jar"
end
