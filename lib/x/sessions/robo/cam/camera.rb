require 'rmagick'
require 'fileutils'

module X::Sessions::Robo::Cam
  class Camera
    TMP_DIR = File.expand_path('../../../../../../tmp-cam', __FILE__)
    FRAME_PATH = File.expand_path('../../../../../../frame.jpg', __FILE__)

    def initialize
      # at_exit {stop_cam}
      # trap("HUP") {p '222'; stop_cam}

      # start_cam
    end

    def get_frame
      cam_command

      frame = tmp_files_by_creation_time.last

      return nil unless frame

      FileUtils.cp(frame, FRAME_PATH)
      FRAME_PATH
    end

    protected
    def ensure_cam_is_running
      start_cam unless cam_running?
    end

    def cam_running?
      Process.getpgid(@pid)
    rescue Errno::ESRCH
      false
    end

    def start_cam
      @pid = fork do
        cam_command
      end
    end

    def stop_cam
      `killall -9 imagesnap`
    end

    def cam_command
      `cd '#{TMP_DIR}';imagesnap -d '#{cam_name}' -q`
    end

    def cam_name
      ENV['CAM_NAME'] || "Built-in iSight"
    end

    def empty_tmp_dir
      outdated_tmp_files.each do |file|
        File.unlink file
      end
    end

    def outdated_tmp_files
      tmp_files_by_creation_time[0..-2]
    end

    def tmp_files_by_creation_time
      tmp_files.sort {|a,b| File.stat(a).mtime <=> File.stat(b).mtime}
    end

    def tmp_files
      Dir.entries(TMP_DIR).select {|f| !f.match(/^\.+$/)}.map {|f| File.join(TMP_DIR, f)}
    end
  end
end
