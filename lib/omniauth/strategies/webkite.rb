require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Webkite < OmniAuth::Strategies::OAuth2

      option :name, 'webkite'

      option :fields, [:name, :email]

      option :client_options, {
        site: 'https://auth.webkite.com'
      }

      uid{ raw_info['uid'] }

      info do
        {
          name: raw_info['name'],
          email: raw_info['email']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/me').parsed
      end

    end
  end
end
