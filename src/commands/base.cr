require "athena-console"
require "benchmark"

module AoC::Commands
  abstract class Base < ACON::Command
    class DevNull < IO
      def write(bytes) : Nil
      end

      def read(bytes)
        0
      end
    end

    getter input : IO = STDIN
    getter parts : Array(Int32) = [1, 2]
    getter? benchmark : Bool = false
    private setter input, parts, benchmark

    macro inherited
      @@default_name = {{ @type.name.stringify.split("::").last.underscore }}
      @@default_description = {{ "Run solution for day #{@type.name.stringify[-2..-1].to_i}" }}
    end

    protected def configure
      argument(
        "input",
        description: "the puzzle input",
        default: "inputs/#{name}",
      )

      option(
        "part",
        shotcut: "p",
        description: "the puzzle part (1 or 2)",
        value_mode: ACON::Input::Option::Value.flags(REQUIRED, IS_ARRAY),
        default: %w[1 2],
      )

      option(
        "benchmark",
        shotcut: "b",
        description: "benchmark the solution",
      )
    end

    protected def setup(input, output)
      input_argument = input.argument("input", String)
      if input_argument == "-" || !File.exists?(input_argument)
        output.puts("Waiting for puzzle input...")
      else
        self.input = File.new(input_argument, "r") 
      end

      self.parts = input.option("part", Array(Int32))
      self.benchmark = input.option("benchmark", Bool)
    end

    protected def execute(input, output): ACON::Command::Status
      if benchmark?
        Benchmark.bm do |x|
          {% for part in [1, 2] %}
            x.report({{"part #{part}:"}}) { part_{{ part }}(output, DevNull.new) } if parts.includes?({{ part }})
          {% end %}

          if parts.includes?(1) && parts.includes?(2)
            x.report("total:") do
              part_1(output, DevNull.new)
              part_2(output, DevNull.new)
            end
          end
        end
      else
        {% for part in [1, 2] %}
          output.print({{"part #{part}: "}})
          part_{{ part }}(output, STDOUT) if parts.includes?({{ part }})
        {% end %}
      end

      self.input.close
      Status::SUCCESS
    end

    protected def part_1(output, stdout)
      raise "Not yet implemented"
    end

    protected def part_2(output, stdout)
      raise "Not yet implemented"
    end
  end
end
