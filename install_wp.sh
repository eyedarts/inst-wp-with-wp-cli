#!/bin/bash

# Based on script at: https://github.com/tekapo/inst-wp-with-wp-cli

# License:
# Released under the GPL license
# http://www.gnu.org/copyleft/gpl.html
#
# Copyright 2013 (email : info@eyedarts.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

echo "Please enter the FULL path to your new WP instance: "
echo "/home/[user]/[path]/[to]/[WordPress]/[root]/[directory]"
read WP_INSTALL_FULL_PATH

echo "Setting LOCALE to US."
WP_LOCALE='us'

echo "Please enter DB_USER: "
read DB_USER

echo "Please enter DB_PASSWORD: "
read DB_PASSWORD

echo "Please enter DB_NAME: "
read DB_NAME

echo "Please enter DB_HOST: "
read DB_HOST

echo "Please enter the URL for your WP instance: "
read WP_URL

echo "Please enter the TITLE for your WP instance: "
read WP_TITLE
 
echo "Please enter the admin USERNAME: "
read WP_ADMIN_NAME

echo "Please enter the admin PASSWORD: " 
read WP_ADMIN_PASSWORD

echo "Please enter the admin EMAIL account: "
read WP_ADMIN_EMAIL

echo "*** Setting path for PLUGINS and THEMES lists"
PLUGINS_LIST_FULL_PATH="../plugins-list.txt"
THEMES_LIST_FULL_PATH="../themes-list.txt"

echo "*** Checking to see if the WP-CLI command is installed"
if ! type "wp" > /dev/null
  then
    echo 'WP-CLI is not installed. Please see wp-cli.org for further information about the installing.'
    exit
  else
    echo '*** WP-CLI exists!'
fi

echo "*** Creating WordPress Installation Directory"
mkdir ${WP_INSTALL_FULL_PATH}

echo "*** Downloading CORE WordPress files"
wp core download \
  --locale=${WP_LOCALE} \
  --path=${WP_INSTALL_FULL_PATH}

cd ${WP_INSTALL_FULL_PATH}

echo "*** Creating wp-config.php"
wp core config \
  --dbname=${DB_NAME} \
  --dbuser=${DB_USER} \
  --dbpass=${DB_PASSWORD} \
  --dbhost=${DB_HOST}

echo "*** Installing WP Core"
wp core install \
  --url=${WP_URL} \
  --title=${WP_TITLE} \
  --admin_name=${WP_ADMIN_NAME} \
  --admin_password=${WP_ADMIN_PASSWORD} \
  --admin_email=${WP_ADMIN_EMAIL}

echo "*** Installing Plugins"
if [ -e "${PLUGINS_LIST_FULL_PATH}" ]
  then
    for PLUGIN in $(cat ${PLUGINS_LIST_FULL_PATH})
      do
	wp plugin install ${PLUGIN} --activate
      done
fi

echo "*** Installing Themes"
if [ -e "${THEMES_LIST_FULL_PATH}" ]
  then
    for THEME in $(cat ${THEMES_LIST_FULL_PATH})
      do
	wp theme install ${THEME}
      done
fi

wp theme list
echo "*** Which theme do you want to activate?"
read theme_activate

echo "*** Activating ${theme_activate} theme."
wp theme activate ${theme_activate}

echo "*** Securing wp-config.php"
`chmod 640 wp-config.php` 

echo "*** Installation is complete!"
