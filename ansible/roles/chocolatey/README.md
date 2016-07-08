Role Name
=========

Install Chocolatey on a Windows host.

Requirements
------------

None.

Role Variables
--------------

This is a pretty sraighforward task that only needs constants defined in vars/main.yml.

Dependencies
------------

This is a self-contained playbook. files/install.ps1 was downloaded from https://chocolatey.com/install.ps1. Please check the Chocolatey website for updates to the install script and after proper vetting, update files/install.ps1

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: chocolatey }

License
-------

BSD

Author Information
------------------

Nicolas Landais, Citrix Systems Inc (2015)
