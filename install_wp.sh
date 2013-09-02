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

echo -e "\nPlease enter the \033[33mFULL path\033[0m to your new WP instance: "
echo "/home/[user]/[path]/[to]/[WordPress]/[root]/[directory]"
read WP_INSTALL_FULL_PATH

echo -e "\n\033[33m*** Setting LOCALE to US.\033[0m\n"
WP_LOCALE='us'

echo -e "Please enter \033[33mDB_USER\033[0m: "
read DB_USER
echo

echo -e "Please enter \033[33mDB_PASSWORD\033[0m: "
read DB_PASSWORD
echo

echo -e "Please enter \033[33mDB_NAME\033[0m: "
read DB_NAME
echo

echo -e "Please enter \033[33mDB_HOST\033[0m: "
read DB_HOST
echo

echo -e "Please enter the \033[33mURL\033[0m for your WP instance: "
read WP_URL
echo

echo -e "Please enter the \033[33mTITLE\033[0m for your WP instance: "
read WP_TITLE
echo
 
echo -e "Please enter the admin \033[33mUSERNAME\033[0m: "
read WP_ADMIN_NAME
echo

echo -e "Please enter the admin \033[33mPASSWORD\033[0m: " 
read WP_ADMIN_PASSWORD
echo

echo -e "Please enter the admin \033[33mEMAIL account\033[0m: "
read WP_ADMIN_EMAIL
echo

echo -e "\033[33m*** Setting path for PLUGINS and THEMES lists\033[0m"
PLUGINS_LIST_FULL_PATH="../plugins-list.txt"
THEMES_LIST_FULL_PATH="../themes-list.txt"

echo -e "\033[33m*** Checking to see if the WP-CLI command is installed\033[0m"
if ! type "wp" > /dev/null
  then
    echo -e '\033[31m*** WP-CLI is not installed. Please see wp-cli.org for further information about the installing.\033[0m'
    exit
  else
    echo -e '\033[32m*** WP-CLI exists!\033[0m'
fi

echo -e "\033[33m*** Creating WordPress Installation Directory\033[0m"
mkdir ${WP_INSTALL_FULL_PATH}

echo -e "\033[33m*** Downloading CORE WordPress files\033[0m"
wp core download \
  --locale=${WP_LOCALE} \
  --path=${WP_INSTALL_FULL_PATH}

cd ${WP_INSTALL_FULL_PATH}

echo -e "\033[33m*** Creating wp-config.php\033[0m"
wp core config \
  --dbname=${DB_NAME} \
  --dbuser=${DB_USER} \
  --dbpass=${DB_PASSWORD} \
  --dbhost=${DB_HOST}

echo -e "\033[33m*** Installing WP Core\033[0m"
wp core install \
  --url=${WP_URL} \
  --title=${WP_TITLE} \
  --admin_name=${WP_ADMIN_NAME} \
  --admin_password=${WP_ADMIN_PASSWORD} \
  --admin_email=${WP_ADMIN_EMAIL}

echo -e "\033[33m*** Installing Plugins\033[0m"
if [ -e "${PLUGINS_LIST_FULL_PATH}" ]
  then
    for PLUGIN in $(cat ${PLUGINS_LIST_FULL_PATH})
      do
	wp plugin install ${PLUGIN} --activate
      done
fi

echo -e "\033[33m*** Installing Themes\033[0m"
if [ -e "${THEMES_LIST_FULL_PATH}" ]
  then
    for THEME in $(cat ${THEMES_LIST_FULL_PATH})
      do
	wp theme install ${THEME}
      done
fi

wp theme list
echo -e "\033[33m*** Which theme do you want to activate?\033[0m"
read theme_activate
echo

echo -e "\033[33m*** Activating ${theme_activate} theme.\033[0m"
wp theme activate ${theme_activate}

echo -e "\033[33m*** Securing wp-config.php\033[0m"
`chmod 640 wp-config.php` 

echo -e "\033[32m*** Installation is complete!\033[0m"
