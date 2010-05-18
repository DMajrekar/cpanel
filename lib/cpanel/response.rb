module Cpanel
  class Response
    attr_accessor :data

    def initialize(http_response)
      @data = parse_response(http_response)
    end

    def errors
      return nil if success?
      return statusmsg if statusmsg
      return nil
    end

    def success?
      return status == 1 if status
      true
    end

    def [](key)
      return data[key.to_s]
    end

    def parse_response(http_response)
      raise "NOT YET DEFINED - this should return a hash representing the data returned"
    end

    def method_missing(method, *args, &block)
      return data[method.to_s] if data.has_key?(method.to_s)
      super
    end
  end
end