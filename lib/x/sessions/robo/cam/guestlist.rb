require 'csv'
require 'open-uri'

module X::Sessions::Robo::Cam
  class Guestlist
    URL = 'https://docs.google.com/spreadsheet/pub?key=0Au_LuhlBQUkEdDkzSURKY1Z5X05fcGZ5UFVFYVhfUHc&single=true&gid=2&output=csv'

    attr_reader :guests

    def initialize
      data = open(URL) { |f| f.read }

      @guests = {}
      CSV.new(data).each do |line|
        qr_code_no, name, rest = line
        if qr_code_no && qr_code_no.to_i.to_s == qr_code_no
          @guests[qr_code_no.to_i] = name
        end
      end
    end
  end
end