# Fill out with your AWS credentials
# !!!! WARNING, DO NOT COMMIT SECRETS TO STASH !!!!
# When you using vagrant on Windows, use POSIX paths (c:/path/to/directory)

module MyVars
 ACCESSKEYID = "<Your AWS Access Key ID goes here>"
 SECRETACCESSKEY = "<Your AWS private key goes here>"
 PLAYBOOKSPATH = "<Enter POSIX path to the playbooks cloned from the git repo>"
 KEYPATH = "<Enter POSIX path to the private Key used to SSH into the Ansible host>"
 INSTANCE_NAME = "<Provide a name for the Ansible server instance>"
 ANSIBLE_USER_PASSWD = "Will be provided with the lab workbook"
 HOME_DIRECTORY = "/home/ec2-user"
 SG = "AWS security group which allows access to Ansible server over SSH (port 22)"
 SUBNET_ID = "AWS subnet ID (ie subnet-5ca41876)"
end
