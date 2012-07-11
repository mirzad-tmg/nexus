Description
===========
This is a quick cookbook that will install nexus, set up the init.d entries and configure the logging.

Other actual nexus configuration (such as configuring the repositories to download indexes, cron jobs, etc) will be up to the end user for now.

Later, these will become flags you can set in the role/node configuration.

Requirements
============

Attributes
==========

Usage
=====
Just add this to your node's runlist:

 "run_list": [ "recipe[nexus::nexus]]"
