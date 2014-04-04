# CKAN

[CKAN](http://ckan.org/) is the world’s leading open-source data portal platform.

http://ckan.org/about/

![Screenshot of CKAN](https://www.evernote.com/shard/s21/sh/7d36cc3a-b0ab-4d44-b845-27775ce36c1f/2625d18b327ff3df2e2210292af446cb/deep/0/Welcome---CKAN.png)

## How to run CKAN

### Set environment variables

Set environment variables at the `~/.bash_profile`.

```
export AWS_ACCESS_KEY="MYAWSACCESSKEY"
export AWS_SECRET_ACCESS_KEY="MYAWSSECRETACCESSKEY"
export AWS_EC2_KEYPAIR="mykeypair"
export AWS_EC2_KEYPAIR_PATH="/path/to/.ssh/id_rsa"
```

### Set up the Vagrant

1. Install [VirtualBox](https://www.virtualbox.org/).
2. Install [Vagrant](http://www.vagrantup.com/).
3. Install the vagrant-aws plugin.
    * `vagrant plugin install vagrant-aws`
4. Clone the repository into a local directory.
    * `git clone https://github.com/Launch-with-1-Click/aws-ckan`

### Launch with Vagrant

```
vagrant up --provider=aws
```

### Security Group

* 22 - ssh
* 80 - http

## Getting Started

### Creating a sysadmin user

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

### Customizing look and feel

Some simple customizations to customize the ‘look and feel’ of your CKAN site are available via the UI, at `http://<my-ckan-url>/ckan-admin/config/`.

![CKAN Config Panel](https://www.evernote.com/shard/s21/sh/b4245a4f-a769-433e-8235-d05ee0156c0d/e731f862589c40101fd6d72f46704f2f/deep/0/Administration---CKAN.png)

http://docs.ckan.org/en/ckan-2.2/sysadmin-guide.html

### More information

[Welcome to CKAN’s Documentation](http://docs.ckan.org/en/ckan-2.2/)

## Contributors

* [miya0001](https://github.com/miya0001)


