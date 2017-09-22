module SticapiClient
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Generates config file for use sticapi"

      def copy_config_file
        copy_file "sticapi.yml", "config/sticapi.yml"
      end
    end
  end
end
