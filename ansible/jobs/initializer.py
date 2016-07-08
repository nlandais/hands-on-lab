#!/usr/bin/python
import json, os, argparse
from os import listdir, path
from pprint import pprint
import re

parser = argparse.ArgumentParser(description='This script uses the name of a release package publisehd to S3 to get infomation about a release by scanning the Automation/profiles json files')
parser.add_argument('-p','--package_name', help='Name of package uploaded to S3 (provided by Lambda function triggered on package upload)',required=True)
parser.add_argument('-o','--output', help='Name of the file where the output of the script is directed (ie /home/ec-user/vars.properties)',required=True)
args = parser.parse_args()

def list_profile_files(childPath) :
    fullpath = os.path.join(os.environ["HOME"], childPath)
    files = []
    for name in os.listdir(fullpath):
       if os.path.isfile(os.path.join(fullpath, name)):
        files.append(os.path.join(fullpath, name))
    return files

def match_profile(json_files,regEx):
    for json_file in json_files:
        data = json.loads(open(json_file).read())
        match = re.match(data["package_name_prefix"], regEx, re.M|re.I)
        if match:
            f = open(args.output,'w')
            f.write("{}\n".format('basename=%s' % os.path.splitext(regEx)[0]))
            for key, value in data.items():
                f.write("{}\n".format("%s=%s" % (key,value)))
            return(os.path.basename(json_file))

json_files = list_profile_files("Ansible/profiles")
match_profile(json_files, args.package_name)
