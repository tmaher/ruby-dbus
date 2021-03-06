#!/usr/bin/env ruby
require File.expand_path("../test_helper", __FILE__)
require "test/unit"
require "dbus"

class ByteArrayTest < Test::Unit::TestCase
  def setup
    @bus = DBus::ASessionBus.new
    @svc = @bus.service("org.ruby.service")
    @obj = @svc.object("/org/ruby/MyInstance")
    @obj.introspect
    @obj.default_iface = "org.ruby.SampleInterface"
  end


  def test_passing_byte_array
    data = [0, 77, 255]
    result = @obj.mirror_byte_array(data).first
    assert_equal data, result
  end

  def test_passing_byte_array_from_string
    data = "AAA"
    result = @obj.mirror_byte_array(data).first
    assert_equal [65, 65, 65], result
  end

  def test_passing_byte_array_from_hash
    # Hash is an Enumerable, but is caught earlier
    data = { "this will" => "fail" }
    assert_raises DBus::TypeException do
      @obj.mirror_byte_array(data).first
    end
  end

  def test_passing_byte_array_from_nonenumerable
    data = Time.now
    assert_raises DBus::TypeException do
       @obj.mirror_byte_array(data).first
    end
  end
end
