# hands-on-lab


###Setting up a core Ansible server:
`cd into the vagrant folders`
> run vagrant up
If things blow up keep calm and check. Errors usually stem from vars.rb file. Otherwise, check your git status and revert any changes
that may have inadvertently found their way into the vagrantfile
Wait ... and wait some more ... Once the process finishes

###Running your first playbook:
So, let's run a playbook to configure the Ansible server.
This is a very simple playbook meant to fetch files called modules from GitHub
and place them in the library folder.
`vagrant ssh`
Now you are connected to the Ansible server
`cd ansible`
`ansible-playbook localhost.yml`
... and voila, you just ran your first playbook

**check the results**:
`cd ~/ansible/library`
`ls`
