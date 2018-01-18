require 'devise/strategies/authenticatable'
require 'jwt'
require 'net/http'

module Devise
  module Strategies
    class SticapiAuthenticatable < Authenticatable
      def valid?
        true
      end

      def authenticate!
        if params[:user]
          secret = Sticapi::SticapiClient.instance.access_token
          payload = {
            user: params[:user][:username],
            password: params[:user][:password]
          }
          token = JWT.encode payload, secret, 'HS256'

          uri = URI.parse("#{Sticapi::SticapiClient.instance.uri}/users/log_in")
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Post.new(uri.request_uri)
          request['Content-Type'] = 'application/json'
          request['access-token'] = Sticapi::SticapiClient.instance.access_token
          request['client'] = Sticapi::SticapiClient.instance.client
          request['uid'] = Sticapi::SticapiClient.instance.uid
          request.body = { data: token }.to_json
          response = http.request(request)
          Sticapi::SticapiClient.instance.update_token(response)

          case response
            when Net::HTTPSuccess
              data = JSON.parse(response.body)
              if data['user']
                unless user = User.find_by(username: data['user']['username'])
                  user = User.new
                  user.name = data['user']['name'] if user.respond_to? :name
                  user.username = data['user']['username'] if user.respond_to? :username
                  user.email = data['user']['email']
                  user.cpf = data['user']['cpf'] if user.respond_to? :cpf
                  user.password = params[:user][:password]
                end
                user.unities = data['user']['unities'] if user.respond_to? :unities
                user.save
                success!(user)
                return
              else
                return fail(:invalid)
              end
            when Net::HTTPUnauthorized
              return fail(:invalid)
            when Net::HTTPServerError
              return fail(:invalid)
            else
              return fail(:invalid)
          end
        end
        return fail(:invalid)
      end
    end
  end
end

Warden::Strategies.add(:sticapi_authenticatable, Devise::Strategies::SticapiAuthenticatable)
