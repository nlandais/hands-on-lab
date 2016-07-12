# hands-on-lab

### Goal

The goal of this lab is to set up a webserver.

The webserver is to fetch a "package" from the `ctxs-lab-content` S3
bucket. The webserver needs to be publicly accessible for HTTP and
RDP. To manage the webserver we will create an Ansible master. The
ansible master needs be available for public SSH.

### Setting up a core Ansible server:
With this exercise, we'll be using Terraform to automatically spin up a pre-configured Ansible AMI to expedite to help us hit the ground running.

### Running your first playbook:
So, let's run a playbook to configure the Ansible server.
This is a very simple playbook meant to fetch files called modules from GitHub
and place them in the library folder.

First connect to the Ansible server via SSH

`ssh -i <path to DevOps-lab.pem> ec2-user@<public IP for the Ansible server>`

Now that you are connected to the Ansible server

+ `cd ansible\library`

+ `rm -f *`

+ `cd ~/ansible`

+ `ansible-playbook localhost.yml`


... and voila, you just ran your first playbook

#### **checking the results**:
To visualize the changes resulting from running the playbook, while logged into the Ansible server run:

+ `cd ~/ansible/library`

+ `ls`


### Provisioning a Windows instance to run a static website

This goal of this excercise is to provision an instance from a template, install IIS and fetch a package from S3
which contains the website assets. Playbooks run as part of this lab are very similar to the steps used to deploy
the ShareFile webapp and api servers running in the AWS cloud.

##### Step 1: Configuring the Ansible server to work in your VPC

+ `cd ~/ansible/roles/common/vars`

Use your favorite text editor to edit defaults.yml, provide the values for your VPC to the variables
subnet\_id, windows\_security\_groups and region

##### Step 2: Deploying a simple static website

+ `cd ~/ansible`

+ `ansible-playbook sample.yml -e "tag=<tag to identify your webserver in the AWS console>"`

+ wait until the playbook completes, it will take a little while...

If it all worked as expected, from your workstation, open your favorite web browser and enter the provisioned web server
public IP to browse the automatically deployed web site.


#### AMI Map

Use these AMIs. (Terraform has them pre-loaded.)

                    US-EAST-1       US-WEST-1      US-WEST-2
    Ansible AMI     ami-923cbc85    ami-2589cf45   ami-8f68abef
    Webhost AMI     ami-9ce8688b    ami-4197d121   ami-e067a480
>>>>>>> document AMI map
