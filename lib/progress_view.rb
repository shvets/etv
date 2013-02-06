require "ruby-progressbar"
require 'script_executor'
require 'media_utils'

class ProgressView
  include Executable

  #def display command
  #  puts "Command: #{command}"
  #
  #  execute({:script => command})
  #end

  def display command
    puts "Command: #{command}"

    progressbar = ProgressBar.create(:title => "Process", :format => '%t: %a %B %p%%', :total => 100)
    duration = 0

    if command =~ /ffmpeg/
      line_action = ffmpeg_line_action(progressbar, duration)
    elsif command =~ /mencoder/
      line_action = mencoder_line_action(progressbar, duration)
    elsif command =~ /mplayer/
      line_action = mplayer_line_action(progressbar, duration)
    else
      line_action = lambda {|_|}
    end

    execute({:script => command, :line_action => line_action})

    progressbar.finish unless progressbar.finished?
  end

  def ffmpeg_line_action progressbar, duration
    lambda do |line|
      result = line.scan(/Duration: (\d{2}):(\d{2}):(\d{2}).(\d{1})/)[0]

      if result
        duration = MediaUtils.how_long(result[0], result[1], result[2], result[3])
      else
        result = line.scan(/time=(\d{2}):(\d{2}):(\d{2}).(\d{2})/)[0]

        if result
          if not duration.nil? and duration != 0
            time = MediaUtils.how_long(result[0], result[1], result[2], result[3])
          else
            time = 0
          end

          progress = time / duration * 100

          progressbar.progress = (progress < duration) ? progress : duration
        end
      end
    end
  end

  def mplayer_line_action progressbar, duration
    lambda do |line|
      #p line

      result = line.scan(/dump: (\d*) bytes written/)[0]

      #p result

      if result
        progress = result[0].to_i

        #p progress

        progressbar.progress = (progress < duration) ? progress : duration
      end
    end
  end

  #\e[0;37mMPlayer 1.1-4.2.1 (C) 2000-2012 MPlayer Team\n\e[0m\e[0;37m\n
  #Playing mms://208.100.43.194/streams_f/stb1_10_835fe539841a8c6715b591373b5e5966.wmv.\n\e[0m\e[0;37mSTREAM_ASF,
  #    URL: mms://208.100.43.194/streams_f/stb1_10_835fe539841a8c6715b591373b5e5966.wmv\n\e[0m\e[0;32m
  #Resolving 208.100.43.194 for AF_INET6...\n\e[0m\e[0;32mConnecting to server 208.100.43.194[208.100.43.194]: 1755...\n
  #\e[0m\n\e[0;37mConnected\n\e[0m\e[0;37mfile object, packet length = 16000 (16000)\n\e[0m\e[0;37mstream object, stream ID: 1\n
  #\e[0m\e[0;37mstream object, stream ID: 2\n\e[0m\e[0;37mdata object\n\e[0m\e[0;37mmmst packet_length = 16000\n\e[0m\e[0;37m
  #Cache size set to 0 KBytes\n\e[0m\e[0;37mStream not seekable!\n\e[0m\e[0;37mASF file format detected.\n\e[0m\e[0;37m[asfheader]
  #Audio stream found, -aid 1\n\e[0m\e[0;37m[asfheader] Video stream found, -vid 2\n\e[0m\e[0;37mStream not seekable!\n\e[0m\e[0;37m
  #VIDEO:  [WMV3]  720x576  24bpp  1000.000 fps  571.0 kbps (69.7 kbyte/s)\n\e[0m\e[0;32mdump: 6503 bytes written\r"

  def mencoder_line_action progressbar, duration
    lambda do |line|

      result = line.scan(/Pos: (\d{2}):(\d{2}):(\d{2}).(\d{1})/)[0]

      if result
        progress = 10
        progressbar.progress = (progress < duration) ? progress : duration
      end
    end

    #@Pos:  15.1s    364f (32%) 25.97fps Trem:   0min   5mb  A-V:-0.006 [831:20]
    # MEncoder 1.1-4.2.1 (C) 2000-2012 MPlayer Team
  end


  #def execute_with_progressbar(command, duration_block, next_position_block)
  #  length = 100
  #  progressbar = ProgressBar.create(title: "movie", format: '%t: %a %B %p%%', length: length)
  #
  #  duration = 0
  #
  #  execute_with_block(command) do |line|
  #    if duration == 0
  #      result1 = duration_block.call(line)
  #
  #      duration = result1 if result1
  #    end
  #
  #    result2 = next_position_block.call(line)
  #
  #    if result2
  #      if duration and duration != 0
  #        position = result2 * length / duration
  #      else
  #        position = 0
  #      end
  #
  #      position = length if position > length
  #
  #      progressbar.progress = position
  #    end
  #  end
  #
  #  progressbar.finish
  #end
end

#def execute_mencoder(command)
#  progress = nil
#  IO.popen(command) do |pipe|
#    pipe.each("\r") do |line|
#      if line =~ /Pos:[^(]*(\s*(\d+)%)/
#        p = $1.to_i
#        p = 100 if p > 100
#        if progress != p
#          progress = p
#          print "PROGRESS: #{progress}\n"
#          $stdout.flush
#        end
#      end
#    end
#  end
#  raise MediaFormatException if $?.exitstatus != 0
#end