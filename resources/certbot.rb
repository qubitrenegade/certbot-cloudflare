# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html

provides :certbot
resource_name :certbot

property :domains, [String, Array], name_property: true, coerce: proc { |x| [x].flatten }
property :post_hook, [String, Array], coerce: proc { |x| [x].flatten }

default_action :install

action :install do
  converge_by 'running certbot cli client' do
    certbot
  end
end

action_class do
  include Chef::Mixin::ShellOut
  include CertbotCF::Helpers

  def certbot
    run
  end

  def run
    shell_out!(
      cmd,
      live_stream: STDOUT
    )
  end

  def cmd
    cmd = 'certbot certonly -q'
    cmd += ' -a dns-cloudflare'
    cmd += " --dns-cloudflare-credentials #{cf_credentials_path}"
    cmd += ' --dns-cloudflare-propagation-seconds '
    cmd += cf_dns_propagation_seconds.to_s
    cmd += " --server #{certbot_server}"
    cmd += ' --dry-run' if certbot_dry_run?
    cmd += ' --agree-tos' if certbot_agree_to_tos?
    cmd += " --email #{certbot_email}" if certbot_email
    cmd += ' --expand'
    cmd += " --domains #{new_resource.domains.join ','}"
    new_resource.post_hook.each do |hook|
      cmd += " --post-hook '#{hook}'"
    end
    cmd
  end
end
