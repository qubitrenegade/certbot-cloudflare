require_relative './helpers'

module CertbotExec
  module Cloudflare
    include CloudflareHelpers
    def extra_args
      [
        '-a dns-cloudflare',
        "--dns-cloudflare-credentials #{cf_credentials_path}",
        "--dns-cloudflare-propagation-seconds #{cf_dns_propagation_seconds}",
      ] + super
    end
  end
  module CertbotCmd
    prepend Cloudflare
  end

  module CertbotExecExtensions
    include CloudflareHelpers
    def initial_setup
      with_run_context :root do
        file cf_credentials_path do
          content <<~END_CONTENT
            dns_cloudflare_email = "#{cf_email}"
            dns_cloudflare_api_key = "#{cf_api_key}"
          END_CONTENT
          mode '0600'
          sensitive true
          action :create
          subscribes :create, 'certbot_cmd[execute-certbot]', :before
        end
      end
      super
    end

    def certbot_install_packages
      # super
      # find_r.packages += ['python3-certbot-dns-cloudflare']
      new_resource.packages += ['python3-certbot-dns-cloudflare']
      super
    end
  end
  module CertbotExecResource
    prepend CertbotExecExtensions
  end
end
