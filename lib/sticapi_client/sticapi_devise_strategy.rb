require 'devise/strategies/authenticatable'
require 'jwt'

module Devise
  module Strategies
    class SticapiAuthenticatable < Authenticatable
      def valid?
        true
      end

      def authenticate!
        if params[:user]
          secret = SticapiClient::SticapiClient.instance.access_token
          payload = {
            user: params[:user][:username],
            password: params[:user][:password]
          }
          token = JWT.encode payload, secret, 'HS256'

          uri = URI.parse("#{SticapiClient::SticapiClient.instance.uri}/users/log_in")
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Post.new(uri.request_uri)
          request['Content-Type'] = 'application/json'
          request['access_token'] = SticapiClient::SticapiClient.instance.access_token
          request['client'] = SticapiClient::SticapiClient.instance.client
          request['uid'] = SticapiClient::SticapiClient.instance.uid
          request.body = { data: token }.to_json
          response = http.request(request)
          SticapiClient::SticapiClient.instance.update_token(response)

          case response
            when Net::HTTPSuccess
              data = JSON.parse response.body
              unless user = User.find_by(cpf: data['user']['cpf'])
                user = User.new
                user.name = data['user']['name'] if user.respond_to? :name
                user.username = data['user']['username'] if user.respond_to? :username
                user.email = data['user']['email']
                user.cpf = data['user']['cpf'] if user.respond_to? :cpf
                user.unities = data['user']['unities'] if user.respond_to? :unities
                user.password = params[:user][:password]
                user.save
              end
              success!(user)
              return
            when Net::HTTPUnauthorized
              {'error' => "#{response.message}: username and password set and correct?"}
              fail
            when Net::HTTPServerError
              {'error' => "#{response.message}: try again later?"}
              fail
            else
              {'error' => response.message}
              fail
          end
        end
        fail
      end
    end
  end
end

Warden::Strategies.add(:sticapi_authenticatable, Devise::Strategies::SticapiAuthenticatable)
