Description
===========
This is a quick cookbook that will install nexus, set up the init.d entries and configure the logging.

Other actual nexus configuration (such as configuring the repositories to download indexes, cron jobs, etc) will be up to the end user for now.

Later, these will become flags you can set in the role/node configuration.

This cookbook has the option to use a certificate and key pair that should be stored in an encrypted databag for the nginx portion of the configuration.

It's up to you (the consumer of this cookbook) to manage where the key for the encrypted databag will be stored.  Our recommendation is to have a "base" cookbook
 that all your recipes can depend on which would set up administrators, users and the basics including putting this key under the root user's ownership in the "/etc/chef" directory, 
the default place chef will look for keys for databags.

Requirements
============
This cookbook requires you have the following cookbooks installed (or unpacked locally in the case of chef-solo):
nginx
ohai
java - I'm controlling the java version and where to find the tar for it in a role file that looks like this:

{
  "default_attributes": {
  },
  "name": "java7",
  "chef_type": "role",
  "env_run_lists": {
  },
  "description": "",
  "json_class": "Chef::Role",
  "override_attributes": {
  "java": {
    "jdk": {
      "6": {
        "x86_64": {
          "url": "http://bafs.tor.rapid7.com/com/oracle/j2se-jdk/1.7.0_04/linux-x86_64/jdk-7u4-linux-x64.tar.gz",
          "checksum": "92fbec82f2a33126b323877d012239ce516518c59073416116799d26fc70307c"
        }
      }
    }
   }
  },
  "run_list": [

  ]
}




Attributes
==========
default[:nexus][:username] - This is the username that will be responsible for setting up/runnin nexus (typically, we just use "nexus").
default[:nexus][:installdir] - This is the location in which we will be unzipping the nexus tarball into.
default[:nexus][:logdir] - This is the location to which we will be writing our log files.

Usage
=====
Just add this to your node's runlist:

 "run_list": [ "recipe[nexus::default]]"
