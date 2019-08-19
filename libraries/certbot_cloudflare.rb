require_relative './helpers'

module CertbotExec
  module Cloudflare
    include CloudflareHelpers
    def extra_args
      [
        '-a dns-cloudflare',
        "--dns-cloudflare-credentials #{certbot_cf_credentials_path}",
        "--dns-cloudflare-propagation-seconds #{certbot_cf_dns_propagation_seconds}",
      ] + super
    end
  end
  module CertbotCmd
    prepend Cloudflare
  end

  module CloudflarePackages
    include CloudflareHelpers
    def package_list
      certbot_cf_packages + super
    end
  end
  module PkgResource
    prepend CloudflarePackages
  end

  module CertbotExecExtensions
    include CloudflareHelpers
    def initial_setup
      with_run_context :root do
        file certbot_cf_credentials_path do
          content <<~END_CONTENT
            dns_cloudflare_email = "#{certbot_cf_email}"
            dns_cloudflare_api_key = "#{certbot_cf_api_key}"
          END_CONTENT
          mode '0600'
          sensitive true
          action :create
          subscribes :create, 'certbot_cmd[execute-certbot]', :before
        end
      end
      super
    end
  end
  module CertbotExecResource
    prepend CertbotExecExtensions
  end
end
