require "x/sessions/robo/cam/version"

module X
  module Sessions
    module Robo
      module Cam
        ROOT_DIR = File.dirname(__FILE__)
      end
    end
  end
end

require "x/sessions/robo/cam/camera"
require "x/sessions/robo/cam/qr_reader"
require "x/sessions/robo/cam/decoder"
require "x/sessions/robo/cam/server"
require "x/sessions/robo/cam/guestlist"