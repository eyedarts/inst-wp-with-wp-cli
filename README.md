inst-wp-with-wp-cli
===================

This is a shell script to install WordPress with [wp-cli](http://wp-cli.org/). It's based on [tekapo's](https://github.com/tekapo/inst-wp-with-wp-cli) script.

The script will prompt you for all information needed during the WordPress installation.

Use <pre><code>./install_wp.sh</pre></code> to run the script.

Database
--------
The script **DOES NOT** create the database. The shared hosting that I use doesn't allow database creation via the command line. You will need to create the database before running this script and input the database information when requested.


Supporting Files Location
-------------------------
The script will look for the plugins-list.txt and themes-list.txt files one directory up from the WordPress root directory.

If wp-config.php is located in <pre><code>/home/[usr]/www</pre></code> then this script will assume the plugins and themes files are in <pre><code>/home/[usr]</pre></code>


The script
----------

1. Collects the needed information
2. Creates the installation directory
3. Downloads latest WordPress Core files
4. Creates wp-config.php
5. Installs WordPress
6. Installs and activates plugins based on plugins-list.txt
7. Installs themes based on themes-list.txt
8. Asks user which theme to activate and activates that theme
9. Changes wp-config.php permissions to 640
