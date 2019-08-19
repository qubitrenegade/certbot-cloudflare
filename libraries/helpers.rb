
module CertbotExec
  module CloudflareHelpers
    def certbot_cf
      node['certbot-exec-cloudflare']
    end

    def certbot_cf_agree_to_tos?
      certbot_cf['agree_to_tos']
    end

    def certbot_cf_email
      certbot_cf['email'] || node['certbot-exec']['email']
    end

    def certbot_cf_packages
      certbot_cf['packages']
    end

    %w(api_key credentials_path
       dns_propagation_seconds).each do |method|
      define_method :"certbot_cf_#{method}" do
        certbot_cf[method]
      end
    end
  end
end
