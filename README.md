Adding to your Rails app
------------------------

In config/application.rb

```
config.middleware.use OmniAuth::Builder do
  provider :webkite, MY_CLIENT_ID, MY_CLIENT_SECRET,
    client_options: { site: https://auth.webkite.org }
end
```
