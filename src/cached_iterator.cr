module AoC
  class CachedIterator(T)
    include Iterator(T)
    include IteratorWrapper

    private getter cached_values, index
    private setter index

    def initialize(@iterator : Iterator(T))
      @cached_values = [] of T
      @index = 0
    end

    def next
      return cached_values[index] if index < cached_values.size
      wrapped_next.tap do |value|
        @cached_values << value
      end
    ensure
      self.index += 1
    end

    def rewind
      self.index = 0
      self
    end
  end
end
