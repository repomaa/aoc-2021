require "athena-console"
require "http/client"

module AoC::Commands
  class FetchInput < ACON::Command
    @@default_name = "fetch-input"
    @@default_description = "fetches puzzle inputs"

    protected def configure
      argument("day", description: "the day to fetch the input for", default: Time.local.day)
      option(
        "session-key", "s",
        description: "your personal aoc session key",
        value_mode: :required,
      )
      option(
        "output", "o",
        description: "write output to file",
        default: "inputs/day%02d" % Time.local.day,
        value_mode: :required,
      )
    end

    protected def interact(input, output)
      session_key = input.option("session-key", String?) || ENV["AOC_SESSION_KEY"]?

      if session_key.nil?
        question = ACON::Question(String?).new("What is your aoc session key?", nil)
        session_key = helper(ACON::Helper::Question).ask(input, output, question)
      end

      input.set_option("session-key", session_key)
    end

    protected def execute(input, output) : ACON::Command::Status
      day = input.argument("day", Int32)
      session_key = input.option("session-key", String)
      output_path = input.option("output", String)
      output = output_path == "-" ? STDOUT : File.new(output_path, "w+")

      client = HTTP::Client.new(URI.parse("https://adventofcode.com"))
      client.before_request { |request| request.cookies["session"] = session_key }
      client.get("/2021/day/#{day}/input") do |response|
        raise response.body_io.gets_to_end unless response.success?
        IO.copy(response.body_io, output)
      end

      output.close
      ACON::Command::Status::SUCCESS
    end
  end
end
