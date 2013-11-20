require 'net/http'
require 'uri'

module X::Sessions::Robo::Cam
  class Decoder
    def self.url_to_badge_no(url)
      real_url = resolve_url_redirect(url)
      File.basename(real_url)
    end

    protected
    def self.resolve_url_redirect(url)
      Net::HTTP.get_response(URI.parse(url))['location']
    end
  end
end