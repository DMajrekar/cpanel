require 'cgi'

module Cpanel
  class Manage2
    MANAGE_2_URL = "https://manage2.cpanel.net"

    attr_reader :username, :password

    # The +username+ and +password+ for the manage2 account is required
    #
    def initialize(username, password)
      @username = username
      @password = password
    end

    # Get the license information from Manage2 using 'XMLlicenseInfo'. Returns a Cpanel::Reponse. Access to
    # the license hash is through the +license+ method on the Cpanel:Reponse
    #
    #   manage2.licenses #=> Cpanel::Reponse
    #
    def licenses
      Cpanel::Response::Yaml.new(get('/XMLlicenseInfo.cgi?output=yaml'))
    end

    # Add a license for the given +ip_address+ to the manage 2 account. The Terms and conditions are automatically accepted.
    #
    # +options+ is a hash that may contain:
    #   * groupid   - defaults to the first group from Cpanel::Manage2#groups
    #   * packageid - defaults to the first package from Cpanel::Manage2#packages
    #   * force     - defaults to 0
    #
    def add_license(ip_address, options = {})
      api_options = {
        'ip'        => ip_address,
        'legal'     => 1,
        'groupid'   => options['groupid']   || options[:groupid]   || groups.keys.first,
        'packageid' => options['packageid'] || options[:packageid] || packages.keys.first,
        'force'     => options['force']     || options[:force]     || '0',
        'output'    => 'yaml'
      }

      # manage2 api docs recomend a post but Net::HTTP::Post requires all values in post data to be a string.
      # The manage2 api does not support legal being a string so we need to do a get request
      get_url = '/XMLlicenseAdd.cgi?' + api_options.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')
      return Cpanel::Response::Yaml.new(get(get_url))
    end

    # Expire a license from the given +id+ from the manage 2 account
    #
    def expire_license(id, reason, expcode = 'normal')
      return Cpanel::Response::Yaml.new(get("/XMLlicenseExpire.cgi?liscid=#{id}&expcode=#{expcode}&output=yaml&reason=#{CGI::escape(reason)}"))
    end

    # Get the current groups from Manage2 using 'XMLgroupInfo'. Returns a Cpanel::Response. Access to the
    # groups has is through the +groups+ method on the Cpanel::Response
    #
    #   manage2.groups #=> Cpanel::Response
    #
    def groups
      Cpanel::Response::Yaml.new(get('/XMLgroupInfo.cgi?output=yaml'))
    end

    # Get the current packages from Manage2 using 'XMpackageInfo'. Returns a Cpanel::Response. Access to the
    # packages has is through the +packages+ method on the Cpanel::Response
    #
    #   manage2.groups #=> Cpanel::Response
    #
    def packages
      Cpanel::Response::Yaml.new(get('/XMLpackageInfo.cgi?output=yaml'))
    end

    private
  
    # Make a get request to manage 2 and return the response
    #
    def get(api_method) #:nodoc:
      do_request(Net::HTTP::Get.new(api_method))
    end

    # Make a post request to manage 2 and return the response
    #
    def post(api_method, options) #:nodoc:
      do_request(Net::HTTP::Post.new(api_method, options))
    end

    # Make a request to manage 2 using +req+ and return the response
    #
    def do_request(req) #:nodoc:
#   raise req.to_hash.inspect
      response = nil
      url = URI.parse(MANAGE_2_URL)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      req.basic_auth(username, password)
      return http.request(req)
    end
  end
end