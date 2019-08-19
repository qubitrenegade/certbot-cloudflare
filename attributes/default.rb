default['certbot-exec-cloudflare'] = {
  # This is default to false,
  # you must set it to true to denote your acceptance of _their_ TOS
  # https://www.cloudflare.com/terms/
  agree_to_tos: false,

  # (required) CloudFlare Global API key
  api_key: 'DEADBEEF',

  # CloudFlare email address (optional), defaults to node['certbot-exec']['email']
  email: nil,

  # path to file with cloudflare email and api key
  credentials_path: '/etc/cloudflare-certbot.ini',

  # --dns-propagation-seconds cli flag
  dns_propagation_seconds: 10,
  packages: case node['platform']
            when 'redhat', 'centos'
              %w(python2-certbot-dns-cloudflare)
            when 'ubuntu', 'debian'
              %w(python3-certbot-dns-cloudflare)
            end
}
