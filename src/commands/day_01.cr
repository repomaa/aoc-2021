require "./base"
require "../cached_iterator"

module AoC::Commands
  class Day01 < Base
    private getter! readings : CachedIterator(Int32)
    private setter readings

    def setup(input, output)
      super
      self.readings = CachedIterator.new(self.input.each_line.map(&.to_i))
    end

    def part_1(output, stdout)
      result = readings.rewind.cons(2).count do |(a, b)|
        a < b
      end

      stdout.puts(result)
    end

    def part_2(output, stdout)
      result = readings.rewind.cons(3).map(&.sum).cons(2).count do |(a, b)|
        a < b
      end

      stdout.puts(result)
    end
  end
end
