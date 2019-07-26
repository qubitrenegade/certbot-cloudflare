# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html

provides :certbot_cf
resource_name :certbot_cf

property :domains, [String, Array], name_property: true, coerce: proc { |x| [x].flatten }
property :post_hook, [String, Array], coerce: proc { |x| [x].flatten }
default_action :install

action :install do
  r = with_run_context :parent do
    setup_repo
    install_packages
    create_credentials_file

    find_resource :certbot, 'collected_domains' do |_new_resource|
      domains []
      post_hook []
    end
  end
  r.domains += new_resource.domains
  r.post_hook += new_resource.post_hook if new_resource.post_hook
end

def after_created
  run_action(:install)
  action :nothing # don't run twice
end

action_class do
  include Chef::Mixin::ShellOut
  include CertbotCF::Helpers

  def setup_repo
    case node[:platform]
    when 'redhat', 'centos'
      include_recipe 'yum-epel'
    when 'ubuntu', 'debian'
      apt_repository 'certbot' do
        uri 'ppa:certbot/certbot'
      end
    end
  end

  def install_packages
    case node[:platform]
    when 'redhat', 'centos'
      package %w(
        certbot
        python2-certbot-dns-cloudflare
      )
    when 'ubuntu', 'debian'
      package %w(
        certbot
        python3-certbot-dns-cloudflare
      )
    end
  end

  def create_credentials_file
    template cf_credentials_path do
      template 'cloudflare-certbot.ini'
      mode '0600'
      variables(
        email: cf_email,
        api_key: cf_api_key
      )
      sensitive true
      action :create
    end
  end
end
