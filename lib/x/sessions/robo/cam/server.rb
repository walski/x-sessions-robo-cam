require 'json'

module X::Sessions::Robo::Cam
  class Server
    def initialize
      guestlist = Guestlist.new

      last_badge_no = nil

      camera = Camera.new
      while true
        image = camera.get_frame

        next unless image

        url = QrReader.read_from_image(image)

        if url
          if url.match /^http(s?):\/\//
            badge_no = Decoder.url_to_badge_no(url)
            persist_no(badge_no)
            puts "Detected badge ##{badge_no}"

            badge_no = badge_no.to_i if badge_no

            if badge_no != last_badge_no
              guest = guestlist.guests[badge_no]
              say_name(guest)
            end

            last_badge_no = badge_no
          else
            puts "Detected badge ##{url}"
          end
        end
        sleep 1
      end
    end

    protected
    def say_name(name)
      return unless name
      `say -v Markus 'Hallo #{name}'`
    end

    def persist_no(no)
      data = {no: no, time: Time.now.to_i}

      output_path = File.join(ROOT_DIR, 'last_detection.json')
      File.open(output_path, 'w') {|f| f.write JSON.dump(data)}
    end
  end
end