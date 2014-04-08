# CKAN

## 1. OVERVIEW

CKAN is a powerful data management system that makes data accessible – by providing tools to streamline publishing, sharing, finding and using data. CKAN is aimed at data publishers (national and regional governments, companies and organizations) wanting to make their data open and available.


## 2. COMPONENTS

* Ubuntu 13.10
* Apache
* Nginx
* PostgreSQL
* Python
* CKAN 2.2

## 3. URLs

```
http://${public_hostname}/
```

## 4. DEFAULT USERNAMES AND PASSWORDS

* PostgreSQL
    * User: ckan_default
    * Password: Random Password (See /etc/ckan/default/production.ini)

## 5. Creating a sysadmin user

You have to use CKAN’s command line interface to create your first sysadmin user.

CKAN commands are executed using the paster command on the server that CKAN is installed on. Before running the paster commands below, you need to make sure that your virtualenv is activated and that you're in your ckan source directory.

```
. /usr/lib/ckan/default/bin/activate
cd /usr/lib/ckan/default/src/ckan
```

You have to create your first CKAN sysadmin user from the command line. For example, to create a user called seanh and make him a sysadmin:

```
paster sysadmin add seanh -c /etc/ckan/default/production.ini
```

http://docs.ckan.org/en/ckan-2.2/getting-started.html#create-admin-user

## 5. Customizing look and feel

Some simple customizations to customize the ‘look and feel’ of your CKAN site are available via the UI, at `http://<my-ckan-url>/ckan-admin/config/`.

![CKAN Config Panel](https://www.evernote.com/shard/s21/sh/b4245a4f-a769-433e-8235-d05ee0156c0d/e731f862589c40101fd6d72f46704f2f/deep/0/Administration---CKAN.png)

http://docs.ckan.org/en/ckan-2.2/sysadmin-guide.html

## 6. Install an Email Server

Install an email server to enable CKAN’s email features (such as sending traceback emails to sysadmins when crashes occur, or sending new activity email notifications to users). For example, to install the Postfix email server, do:

```
sudo apt-get install postfix
```

When asked to choose a Postfix configuration, choose `Internet Site` and press return.

## 7. More information

[Welcome to CKAN’s Documentation](http://docs.ckan.org/en/ckan-2.2/)

## 8. Support

info+ckan@digitalcube.jp
