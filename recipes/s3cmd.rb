# encoding: utf-8
#
# Cookbook Name:: nmdbase
# Recipe:: default
#
# Author:: Kevin Bridges
# Copyright:: 2014, NewMedia Denver
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
package 's3cmd' do
  action :install
end

s3cmd = Chef::EncryptedDataBagItem.load('nmdbase', 's3cmd')[node.chef_environment]

s3cmd=[
  '[default]',
  "access_key = #{s3cmd['AWS_ACCESS_KEY']}",
  'bucket_location = US',
  'cloudfront_host = cloudfront.amazonaws.com',
  'cloudfront_resource = /2010-07-15/distribution',
  'default_mime_type = binary/octet-stream',
  'delete_removed = False',
  'dry_run = False',
  'encoding = UTF-8',
  'encrypt = False',
  'follow_symlinks = False',
  'force = False',
  'get_continue = False',
  'gpg_command = /usr/bin/gpg',
  'gpg_decrypt = %(gpg_command)s -d --verbose --no-use-agent --batch --yes --passphrase-fd %(passphrase_fd)s -o %(output_file)s %(input_file)s',
  'gpg_encrypt = %(gpg_command)s -c --verbose --no-use-agent --batch --yes --passphrase-fd %(passphrase_fd)s -o %(output_file)s %(input_file)s',
  "gpg_passphrase = #{s3cmd['AWS_GPG_PASSPHRASE']}",
  'guess_mime_type = True',
  'host_base = s3.amazonaws.com',
  'host_bucket = %(bucket)s.s3.amazonaws.com',
  'human_readable_sizes = False',
  'list_md5 = False',
  'log_target_prefix =',
  'preserve_attrs = True',
  'progress_meter = True',
  'proxy_host =',
  'proxy_port = 0',
  'recursive = False',
  'recv_chunk = 4096',
  'reduced_redundancy = False',
  "secret_key = #{s3cmd['AWS_SECRET_KEY']}",
  'send_chunk = 4096',
  'simpledb_host = sdb.amazonaws.com',
  'skip_existing = False',
  'socket_timeout = 300',
  'urlencoding_mode = normal',
  'use_https = True',
  'verbosity = WARNING'
]


template "/root/.s3cfg" do
  source 'generic.erb'
  mode 0600
  owner 'root'
  group 'root'
  variables(data: s3cmd)
end
