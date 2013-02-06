require 'spec_helper'

require 'media_utils'

describe MediaUtils do
  it "should convert local wmv to avi" do
    subject.display_progressbar subject.ffmpeg("sample.wmv", "sample.avi")
  end

  it "should convert wmv to mp3" do
    subject.display_progressbar subject.to_mp3("sample.wmv", "sample.mp3")
  end

  it "should convert mp3 to wav" do
    subject.display_progressbar subject.to_mp3("sample.mp3", "sample.wav")
  end

  it "should convert wav to mp3" do
    subject.display_progressbar subject.wav_to_mp3("sample")
  end

  it "should convert wav to mp3" do
    subject.display_progressbar subject.generate_flv("sample.wmv", "sample.flv")
  end

  it "should return duration of media file" do
    duration = subject.get_media_duration("sample.wmv")

    duration.should > 0
  end

  it "should convert remote mms to avi" do
    subject.display_progressbar subject.mencoder "mms://66.231.177.100/streams_f/stb1_10_4451362dbb21e70c024df8f316674d00.wmv", "sample3.avi"
  end

  it "should convert mms to wma" do
    pending
    subject.display_progressbar subject.mplayer "mms://66.231.177.100/streams_f/stb1_10_4451362dbb21e70c024df8f316674d00.wmv", "sample2.wma"
  end

  #it "should convert local wmv to mp3" do
  #  command_mencoder = "mencoder sample.wmv -o output.avi -oac lavc -ovc lavc -lavcopts vcodec=xvid:acodec=mp3"
  #
  #  begin
  #    subject.execute_mencoder(command_mencoder)
  #  rescue Exception => e
  #    p e
  #    print "ERROR\n"
  #    exit 1
  #  end
  #end

end



