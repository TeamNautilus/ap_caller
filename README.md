# api_caller
Call APIs safely.

# Usage
GET
```ruby
ApiCaller.get(uri_string: 'www.my_api.com/v1/interesting_stuffs.json', logger: Rails.logger)
```

POST
required arguments
```ruby
ApiCaller.post(uri_string: 'www.my_api.com/v1/interesting_stuffs', params: '{"key": "value"}')
```
or with optional arguments
```ruby
ApiCaller.post(uri_string: 'www.my_api.com/v1/interesting_stuffs', params: '{"key": "value"}', content_type: {'Content-Type' => 'application/json'}, logger: Rails.logger)
```

# Install
Edit your Gemfile and add:
```ruby
gem 'api_caller'
```
# License
The gem api_caller is released under the MIT License.

# Author
Team Nautilus
