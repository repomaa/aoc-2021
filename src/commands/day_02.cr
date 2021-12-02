require "./base"

module AoC::Commands
  class Day02 < Base
    record Position, horizontal : Int32, depth : Int32, aim : Int32? = nil do
      def +(command : Command)
        if aim = self.aim
          horizontal_delta = command.horizontal_delta
          self.class.new(horizontal + horizontal_delta, depth + aim * horizontal_delta, aim + command.vertical_delta)
        else
          self.class.new(horizontal + command.horizontal_delta, depth + command.vertical_delta)
        end
      end
    end

    record Command, direction : Direction, delta : Int32 do
      enum Direction
        Forward
        Down
        Up
      end

      def self.parse(line)
        direction, delta = line.split(' ')
        new(Direction.parse(direction), delta.to_i)
      end

      def horizontal_delta
        case direction
        when .forward? then delta
        else 0
        end
      end

      def vertical_delta
        case direction
        when .down? then delta
        when .up? then -delta
        else 0
        end
      end
    end

    private getter! commands : CachedIterator(Command)
    private setter commands

    def setup(input, output)
      super
      self.commands = CachedIterator.new(self.input.each_line.map { |line| Command.parse(line) })
    end

    def part_1(output, stdout)
      final_position = commands.rewind.reduce(Position.new(0, 0)) do |position, command|
        position + command
      end

      puts final_position.horizontal * final_position.depth
    end

    def part_2(output, stdout)
      final_position = commands.rewind.reduce(Position.new(0, 0, 0)) do |position, command|
        position + command
      end

      puts final_position.horizontal * final_position.depth
    end
  end
end
