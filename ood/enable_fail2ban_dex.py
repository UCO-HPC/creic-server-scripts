#!/usr/bin/env python3

import datetime
import os
import shutil
import yaml

time_code = datetime.datetime.now().strftime("%Y%m%dT%H%M%S")
config_file = os.path.join("/", "etc", "ood", "dex", "config.yaml")
shutil.copyfile(config_file, config_file + '.' + time_code)
with open(config_file, "r") as file:
    data = yaml.load(file, Loader=yaml.Loader)
print(data["web"])
insert = {
    'header': 'X-Forwarded-For', 
    'trustedProxies': ['127.0.0.1/4']
}
data["web"]['clientRemoteIP'] = insert

with open(config_file, "w") as file:
    yaml.dump(data, file)
