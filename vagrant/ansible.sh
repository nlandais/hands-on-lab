cd /tmp
# Update/patch the system and install the latest version of Ansible
sudo su -c "yum -y update; \
            yum -y install python-pip; \
            yum -y groupinstall 'Development Tools'; \
            python -m pip install -U pip; \
            ln -s /usr/local/bin/pip /usr/bin/pip; \
            pip install boto; \
            pip install boto3; \
            pip install ansible; \
            pip install https://github.com/diyan/pywinrm/archive/master.zip#egg=pywinrm; \
            pip install --upgrade jinja2==2.8"

BOTO_FILE="$HOME/.boto"

if [ ! -f /usr/local/bin/sshpass ]; then
  wget -O sshpass-1.05.tar.gz http://sourceforge.net/projects/sshpass/files/sshpass/1.05/sshpass-1.05.tar.gz/download
  gunzip sshpass-1.05.tar.gz
  tar xvf sshpass-1.05.tar
  pushd sshpass-1.05
  sudo ./configure
  sudo make install
  popd
  sudo rm -rf sshpass-1.05*
fi

cd $HOME

cat > $BOTO_FILE <<EOF
[Credentials]
aws_access_key_id = $1
aws_secret_access_key = $2
EOF

BOTO_PROFILE_DIR="$HOME/.aws"
BOTO_PROFILE="$BOTO_PROFILE_DIR/credentials"
if [ ! -d "$BOTO_PROFILE_DIR" ]; then
  mkdir "$BOTO_PROFILE_DIR"
fi

cat > $BOTO_PROFILE <<EOF
[default]
aws_access_key_id = $1
aws_secret_access_key = $2
EOF

if [ ! -d $HOME/ansible/group_vars ]; then
  mkdir -p $HOME/ansible/group_vars
fi

cat > $HOME/ansible/group_vars/windows.yml <<EOF
ansible_port: 5986
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore
ansible_winrm_transport: ssl
ansible_user: ansible
ansible_password: $3
access_key: $1
secret_key: $2
EOF

#This path must match the value of log_path in ansible.config
if [ ! -d $HOME/ansible/log ]; then
  mkdir -p $HOME/ansible/log
fi

if [ ! -d $HOME/.ssh ]; then
  mkdir -p $HOME/.ssh
  chmod 700 $HOME/.ssh
fi

for file in $( ls -d -1 $HOME/.ssh/* )
do
  chmod 0400 ${file}
done
