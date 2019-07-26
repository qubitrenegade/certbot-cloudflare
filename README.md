# certbot-cloudflare

This cookbook intends to answer the "Chicken and egg" problem of setting up a web server with a self signed cert to obtain a Let's Encrypt signed SSL certifacte.

This does so by leveraging the [`cloudflare-dns`](https://certbot-dns-cloudflare.readthedocs.io/en/stable/) authenticator plugin.  While this does require you are using CloudFlare for DNS, it does not require you use CloudFlare proxying and does not require a running web server.  (for instance, issuing an SSL certificate for an XMPP server).

## Usage

This cookbook is implemented as a library cookbook that can be called from multiple wrapper cookbooks.

For instance, if we're running an xmpp server on `xmpp.exmaple.com` and a web chat client on `chat.example.com`, we'll probably manage each of these services in their own cookbook.  We want each cookbook to be able to leverage `certbot_cf` resource independently of each other, but they should be able to run on the same server, and only trigger our `certbot` run once.

e.g.:

In our xmpp cookbook we might have:

```ruby
# cookbook/xmpp/recipes/default.rb
certbot_cf 'xmpp.example.com'
```

and in our chat cookbook we might have:

```ruby
# cookbook/chat/recipes/default.rb
certbot_cf 'chat.example.com do
  post_hook 'systemctl restart nginx'
end
```

This will accumulate or domains which will result in a certbot commandline:

```bash
certbot ... --domains xmpp.example.com,chat.example.com
```

Note that our domains are accumulated during our compliation phase and executed at the start of our run phase.

### Quick Start

Inlude in `certbot-cloudflare` in your `metadata.rb`.

```ruby
depends 'certbot-cloudflare'
```

Set the minimum required attributes:

```ruby
default['certbot_cf']['agree_to_tos'] = true
default['certbot_cf']['dry_run'] = false
default['certbot_cf']['email'] = 'you@yourdomain.com'
default['certbot_cf']['cloudflare']['api_key'] = 'abc123'
```

Leverage the resource

```ruby
certbot_cf 'foo.example.com', 'bar.example.com'
```

## TODO:

* be more flexible where we get certbot from
* ohai plugin for cert discovery?
