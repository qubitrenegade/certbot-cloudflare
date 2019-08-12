# InSpec test for recipe certbot-exec-cloudflare::default

# The InSpec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package 'certbot' do
  it { should be_installed }
end

if os.debian?
  describe package 'python3-certbot-dns-cloudflare' do
    it { should be_installed }
  end
elsif os.redhat?
  describe package 'python2-certbot-dns-cloudflare' do
    it { should be_installed }
  end
end

describe file '/etc/cloudflare-certbot.ini' do
  its('mode') { should cmp '0600' }
  its('content') do
    should match %r{dns_cloudflare_email = "(.*)"}
  end
  its('content') do
    should match %r{dns_cloudflare_api_key = ".*"}
  end

  its('content') do
    should_not match %r{youneedtosetme@least.com}
  end
  its('content') do
    should_not match %r{DEADBEEF}
  end
end

describe directory '/etc/letsencrypt/live' do
  it { should exist }
end
