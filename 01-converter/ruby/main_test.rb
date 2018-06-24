# frozen_string_literal: true

require "minitest/autorun"
require "pty"
require "expect"

F2C = "0"
C2F = "1"

describe "main" do
  def run_cmd
    path = ENV.fetch("EXE_PATH")

    PTY.spawn(path) do |master, slave|
      yield(master, slave)
    end
  end

  def assert_output(io, pattern)
    refute_equal(nil, io.expect(pattern, 1))
  end

  def assert_line_output(io, line)
    assert_equal("#{line}\r\n", io.gets)
  end

  it "presents itself" do
    expected =
      "Available conversions:\r\n" \
      "\r\n" \
      "  0: Fahrenheit => Celsius\r\n" \
      "  1: Celsius => Fahrenheit\r\n" \
      "\r\n" \
      "Your choice ? "

    run_cmd do |master, _slave|
      actual = master.expect("Your choice ? ", 1).first

      assert_equal(expected, actual)
    end
  end

  it "accepts a valid conversion: Fahrenheit to Celsius" do
    run_cmd do |master, slave|
      assert_output(master, "Your choice ? ")
      slave.puts(F2C)
      assert_line_output(master, F2C)
      assert_output(master, "Your temperature ? ")
    end
  end

  it "accepts a valid conversion: Celsius to Fahrenheit" do
    run_cmd do |master, slave|
      assert_output(master, "Your choice ? ")
      slave.puts(C2F)
      assert_line_output(master, C2F)
      assert_output(master, "Your temperature ? ")
    end
  end

  it "rejects an invalid conversion: afozjo" do
    run_cmd do |master, slave|
      assert_output(master, "Your choice ? ")
      slave.puts("afozjo")
      assert_line_output(master, "afozjo")
      assert_line_output(master, "Please enter a valid conversion.")
      assert_output(master, "Your choice ? ")
    end
  end

  it "accepts a valid temperature: -484.74001 F" do
    run_cmd do |master, slave|
      assert_output(master, "Your choice ? ")
      slave.puts(F2C)
      assert_output(master, "Your temperature ? ")
      slave.puts("-484.74001")
      assert_line_output(master, "-484.74001")
      assert_line_output(master, "-484.74001 Fahrenheit => -287.08 Celsius")
    end
  end

  it "accepts a valid temperature: -287.077778 C" do
    run_cmd do |master, slave|
      assert_output(master, "Your choice ? ")
      slave.puts(C2F)
      assert_output(master, "Your temperature ? ")
      slave.puts("-287.077778")
      assert_line_output(master, "-287.077778")
      assert_line_output(master, "-287.077778 Celsius => -484.74 Fahrenheit")
    end
  end

  it "rejects a invalid temperature: zofjozef F" do
    run_cmd do |master, slave|
      assert_output(master, "Your choice ? ")
      slave.puts(F2C)
      assert_output(master, "Your temperature ? ")
      slave.puts("zofjozef")
      assert_line_output(master, "zofjozef")
      assert_line_output(master, 'Please enter a valid temperature.')
      assert_output(master, "Your temperature ? ")
    end
  end
end
