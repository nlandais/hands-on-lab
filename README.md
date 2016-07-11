# hands-on-lab

### Goal

The goal of this lab is to set up a webserver.

The webserver is to fetch a "package" from the `ctxs-lab-content` S3
bucket. The webserver needs to be publicly accessible for HTTP and
RDP. To manage the webserver we will create an Ansible master. The
ansible master needs be available for public SSH.

### Setting up a core Ansible server:
Run the following commands

+ `cd into the vagrant folders`
+ `run vagrant up`

If things blow up keep calm and check. Errors usually stem from vars.rb file. Otherwise, check your git status and revert any changes
that may have inadvertently found their way into the vagrantfile
Wait ... and wait some more ... Once the process finishes

### Running your first playbook:
So, let's run a playbook to configure the Ansible server.
This is a very simple playbook meant to fetch files called modules from GitHub
and place them in the library folder.

`vagrant ssh`

Now you are connected to the Ansible server
+ `cd ansible`
+ `ansible-playbook localhost.yml`
... and voila, you just ran your first playbook

#### **checking the results**:
To visualize the changes resulting from running the playbook, while logged into the Ansible server run:
+ `cd ~/ansible/library`
+ `ls`
