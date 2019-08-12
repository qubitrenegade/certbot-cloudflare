name              'certbot-exec-cloudflare'
maintainer        'Qubit Renegade'
maintainer_email  'qubitrenegade@protonmail.com'
license           'MIT'
description       'Installs/Configures certbot-exec-cloudflare'
long_description  File.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           '0.1.0'
chef_version      '>= 13.0'

issues_url        'https://github.com/qubitrenegade/certbot-exec-cloudflare/issues'
source_url        'https://github.com/qubitrenegade/certbot-exec-cloudflare'

%w(ubuntu centos).each do |platform|
  supports platform
end
