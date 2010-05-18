module Cpanel
  class Response::Yaml < Cpanel::Response
    def parse_response(http_response)
      YAML::load(http_response.body)
    end
  end
end