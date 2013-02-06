require 'progress_view'
require 'media_utils'

class Converter
  def convert input_file, output_file
    params = MediaUtils.info input_file
    puts "Parameters: #{params}"

    system "rm \"#{output_file}\""

    progress_view = ProgressView.new

    progress_view.display MediaUtils.ffmpeg_with_params(input_file, output_file, params)
  end
end
