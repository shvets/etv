# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

require 'etv/engine/content_manager'

describe ContentManager do

  it "main mode should return items" do
    result = subject.get_items "main"

    result.size.should > 0
  end

  it "channels mode should return items" do
    result = subject.get_items "channels"

    result.size.should > 0
  end

  it "catalog mode should return items" do
    result = subject.get_items "catalog"

    result.size.should > 0
  end

  it "live mode should return items" do
    result = subject.get_items "live"

    result.size.should > 0
  end

  it "audio mode should return items" do
    result = subject.get_items "audio"

    result.size.should > 0
  end

  it "search mode should return items" do
    result = subject.get_items "search", "red"

    result.size.should > 0
  end

  #it "should return search menu items" do
  #  result = subject.get_items "search", "красная шапочка"
  #
  #  result.size.should > 0
  #end
end

