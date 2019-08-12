# certbot-exec-cloudflare

This cookbook is a plugin for the [`certbot-exec`](https://github.com/qubitrenegade/certbot-exec) cookbook that adds the [`certbot-dns-cloudflare`](https://certbot-dns-cloudflare.readthedocs.io/en/stable/) authenticator plugin.  

## Usage

This cookbook is implemented as "library plugin" cookbook.  This means it only needs to be included in a cookbook metadata and it will take the appropriate action to modify the `certbot_exec` resource.

Include in metadata.rb:

```ruby
depends 'certbot-exec'
depends 'certbot-exec-cloudflare'
```

Set minimal attributes:

```ruby
default['certbot-exec-cloudflare']['agree_to_tos'] = true
default['certbot-exec-cloudflare']['api-key'] = 'FOOBAR'
```

Continue using `certbot_exec` as usual:

```ruby
certbot_exec 'foo.example.com'
```

## Attributes

```
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
}
```

## Contributing

PRs and issues welcome!

## License

```
The MIT License (MIT)

Copyright (c) 2019 Qubit Renegade

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
