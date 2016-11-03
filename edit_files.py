import sys

core_site_str = """<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://FIXED_IP:9000</value>
  </property>
  <property>
    <name>hadoop.tmp.dir</name>
    <value>/usr/local/tmp</value>
  </property>
</configuration>"""

hdfs_site_str = """<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->
<configuration>
 <property>
   <name>dfs.replication</name>
   <value>2</value>
 </property>    <property>
         <name>dfs.replication</name>
         <value>2</value>
     </property>
</configuration>"""

def core_site(f,fixed_ip):
  global core_site_str
  core_site_str = core_site_str.replace('FIXED_IP',fixed_ip)
  f.write(core_site_str)
  f.close()

def hdfs_site(f):
  global hdfs_site_str
  f.write(hdfs_site_str)
  f.close()

if __name__ == "__main__":
  file_name = sys.argv[1]
  print file_name
  print type(file_name)
  f = open(file_name,'wb')
  if file_name == 'core-site.xml':
    core_site(f,sys.argv[2])
  elif file_name == 'hdfs-site.xml':
    hdfs_site(f)
