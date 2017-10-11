# encoding: utf-8
require 'sticapi_client/version'
require 'singleton'
require 'devise'
require 'rails'
require 'sticapi_client/sticapi_devise_strategy'
require 'sticapi_client/sticapi_controller'
require 'sticapi_client/etjpi'
require 'net/http'

module SticapiClient
  class SticapiClient
    include Singleton

    attr_accessor :host
    attr_accessor :urn
    attr_accessor :port
    attr_accessor :user
    attr_accessor :password
    attr_accessor :access_token
    attr_accessor :client
    attr_accessor :uid
    attr_accessor :expiry

    def initialize
      configs = YAML.load_file("#{Rails.root}/config/sticapi.yml")[Rails.env]
      # configs = YAML.load_file("/home/ricardo/dev/sticapi_client/lib/generators/sticapi_client/templates/sticapi.yml")[Rails.env]
      @host = configs['host']
      @port = configs['port'] || 80
      @user = configs['user']
      @urn = configs['urn']
      @password = configs['password']
      @access_token = ''
      @client = ''
      @uid = ''
      @expiry = ''
      get_token
    end

    def uri
      "http://#{@host}:#{@port}#{'/' if @urn}#{@urn}"
    end

    def get_token
      if @access_token.blank?
        uri = URI.parse("#{self.uri}/auth/sign_in")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri)
        request['email'] = @user
        request['password'] = @password
        response = http.request(request)
        update_token(response)
      end
    end

    def update_token(response)
      @access_token = response['access-token']
      @client = response['client']
      @uid = response['uid']
      @expiry = response['expiry']
    end

    def sticapi_request(route, options = {})
      kind = options[:kind] || 'post'
      uri = URI.parse("#{self.uri}#{route}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = nil
      request = Net::HTTP::Post.new(uri.request_uri) if kind == 'post'
      request = Net::HTTP::Get.new(uri.request_uri) if kind == 'get'
      request['Content-Type'] = 'application/json'
      request['access-token'] = access_token
      request['client'] = client
      request['uid'] = uid
      request.body = options.except(:kind).to_json
      response = http.request(request)
      update_token(response)
      JSON.parse(response.body)
    end
  end
end

# Add sticapi_authenticatable strategy to defaults.
#
Devise.add_module(:sticapi_authenticatable,
                  :route => :session, ## This will add the routes, rather than in the routes.rb
                  :strategy   => true,
                  :controller => :sessions)
