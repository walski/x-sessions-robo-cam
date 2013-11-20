require 'open3'

module X::Sessions::Robo::Cam
  class QrReader
    def self.read_from_image(file)
      stdin, stdout, stderr, wait_thr = Open3.popen3(command(file))
      qr_code = stdout.read

      qr_code.match(/^\s*$/) ? nil : qr_code
    end

    protected
    def self.command(file)
      "zbarimg --raw '#{file}'"
    end
  end
end