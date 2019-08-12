#
# Chef Documentation
# https://docs.chef.io/libraries.html
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#
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
    %w(api_key credentials_path
       dns_propagation_seconds).each do |method|
      define_method :"certbot_cf_#{method}" do
        certbot_cf[method]
      end
    end
  end
end

#
# The module you have defined may be extended within the recipe to grant the
# recipe the helper methods you define.
#
# Within your recipe you would write:
#
#     extend CertbotCF::Helpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend CertbotCF::Helpers
#       variables specific_key: my_helper_method
#     end
#
