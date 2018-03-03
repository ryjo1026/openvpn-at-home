#!/bin/sh

# Steps to reproduce the bug
# 1. build the project
# 2. run bootstrap to initialize the database
# 3. during bootstrap db migrations is run via call_command('migrate'):
#    - openvpn_server table is created
#    - openvpn_client table is created; it uses foreign key to openvpn_server
#    - openvpn_server table is renamed to openvpn_server__old
#    - openvpn_client foreign key is re-linked to openvpn_server__old
#    - openvpn_server is created and data from openvpn_server__old is copied
#    - openvpn_server__old is dropped
#    - openvpn_client still references openvpn_sever__old - ForeignKey constraint is not updated
# 3. try creating Client object - SQL cannot be executed

make devel
cd backend
source ./env/bin/activate
./manage.py bootstrap

echo '
Now type that:

./manage.py shell
In [1]: from openvpnathome.apps.openvpn.models import Server, Client

In [2]: Client.objects.create()

... snip ...

OperationalError: no such table: main.openvpn_server__old
'

