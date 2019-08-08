override['certbot-exec']['email'] = 'foobar@example.com'
override['certbot-exec']['packages'] = case node['platform']
                                       when 'redhat', 'centos'
                                         %w(
                                           certbot
                                           python2-certbot-dns-cloudflare
                                         )
                                       when 'ubuntu', 'debian'
                                         %w(
                                           certbot
                                           python3-certbot-dns-cloudflare
                                         )
                                       end

default['certbot_cf'] = {
  # This is default to false,
  # you must set it to true to denote your acceptance of _their_ TOS
  # https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf
  agree_to_tos: false,

  # Set to your email you use with Lets Encrypt
  email: 'youneedtosetme@least.com',

  # If this should be a dry run, typically this should be false.
  dry_run: true,

  # Which ACME server to use
  server: 'prod',

  # Cloudflare config settings for cloudflare-dns authenticator
  cloudflare: {
    # (required) CloudFlare Global API key
    api_key: 'DEADBEEF',

    # CloudFlare email address (optional), defaults to same as above
    email: nil,

    # path to file with cloudflare email and api key
    credentials_path: '/etc/cloudflare-certbot.ini',

    # --dns-propagation-seconds cli flag
    dns_propagation_seconds: 10,
  },

  # acme server addresses, these should not need to be adjusted
  acme: {
    prod: 'https://acme-v02.api.letsencrypt.org/directory',
    stage: 'https://acme-staging-v02.api.letsencrypt.org/directory',
  },
}
