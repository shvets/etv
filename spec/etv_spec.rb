require_relative 'spec_helper'

require 'etv/main'

describe Main do

  it "test1" do
    #client.expects(:process_items)
    subject.process
  end

  it "test2" do
    ARGV = ["--channels"]
    #client.expects(:process_items)
    subject.process
  end

  it "test3" do
    keywords = "red"

    subject.process_folder "search", keywords
  end

end

