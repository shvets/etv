require 'script_executor'


# Extracting sound from a video, and save it as Mp3
# ffmpeg -i source_video.avi -vn -ar 44100 -ac 2 -ab 192 -f mp3 sound.mp3

# Convert a wav file to Mp3
# ffmpeg -i son_origine.avi -vn -ar 44100 -ac 2 -ab 192 -f mp3 son_final.mp3

# Compress .avi to divx
# ffmpeg -i video_origine.avi -s 320x240 -vcodec msmpeg4v2 video_finale.avi
# ffmpeg -i stream.wmv  -s 720x480 -b 1000k output.mp4

class MediaUtils

  def self.mplayer url, file_name
    "mplayer -dumpstream #{url} -dumpfile \"#{file_name}\" -nocache -msgcolor"
  end

  def self.mencoder url, file_name
    "mencoder #{url} -ovc copy -oac copy -o #{file_name}"
  end
  # mencoder stream.wmv -o output.avi -oac lavc -ovc lavc -lavcopts vcodec=xvid:acodec=mp3

  def self.ffmpeg input_file, output_file, params=""
    "ffmpeg -y -i #{input_file} #{params} #{output_file} 2>&1"
  end

  def self.vlc url, file_name
    #--intf=rc
    "/Applications/VLC.app/Contents/MacOS/VLC -vvv #{url} --sout file/#{file_name}"
  end

  def dump url
    #execute "/Applications/VLC.app/Contents/MacOS/VLC --intf=rc -vvv \"#{url}\" --sout \"#std{access=file,mux=ps,dst=output.mpg}\""

    #execute "mencoder \"#{url}\" -ovc copy -oac copy -o output.avi -msgcolor -msglevel all=1"
    #execute "mplayer -nocache  -msgcolor -msglevel all=1 -dumpfile stream.wmv -dumpstream #{url}"
  end

  def self.to_mp3 input_file, output_file
    params = "-vn -ar 44100 -ac 2 -ab 192 -f mp3"

    ffmpeg(input_file, output_file, params)
  end

  def self.wav_to_mp3 name
    params = "-ab 128"

    ffmpeg("#{name}.wav", "#{name}.mp3", params)
  end

  def generate_flv input_file, output_file
    paself.rams = "-ab 56 -ar 44100 -b 200 -r 15 -s 320x240 -f flv"

    ffmpeg(input_file, output_file, params)
  end

  def self.get_media_duration(input_file)
    command = "ffmpeg -i #{input_file} 2>&1"

    executor = ScriptExecutor.new

    output = executor.execute({:script => command, :capture_output => true})

    result = output.scan(/Duration: (\d{2}):(\d{2}):(\d{2}).(\d{1})/)[0]

    how_long(result[0], result[1], result[2], result[3])
  end

  def self.how_long hours, minutes, seconds, tenth_seconds
    (hours.to_f * 60 * 60 + minutes.to_f * 60 + "#{seconds}.#{tenth_seconds}".to_f)
  end

  def self.info file_name
    executor = ScriptExecutor.new

    result = executor.execute({:script => "ffmpeg -i #{file_name} 2>&1", :capture_output => true, :suppress_output => true})

    audio = result.scan(/Audio:(.*)/)[0][0]

    audio_bitrate = audio.split(',')[1].strip
    audio_bitrate = audio_bitrate[0..audio_bitrate.index(" ")].strip

    video = result.scan(/Video:(.*)/)[0][0]

    screen_size = video.split(',')[2].strip

    video_bitrate = video.split(',')[3].strip
    video_bitrate = video_bitrate[0..video_bitrate.index(" ")].strip
    video_bitrate = video_bitrate + "k"

    params = {}
    params["audio_bitrate"] = audio_bitrate
    params["video_bitrate"] = video_bitrate
    params["screen_size"] = screen_size

    params
  end

  def self.ffmpeg_with_params input_file, output_file, params
    command = "ffmpeg -i \"#{input_file}\""
    command += " -s #{params["screen_size"]}" if params["screen_size"]
    command += " -b:v #{params["video_bitrate"]}" if params["video_bitrate"]
    command += " -b:a #{params["audio_bitrate"]}" if params["audio_bitrate"]

    command += " \"#{output_file}\""
    command += " 2>&1"

    command
  end

end
