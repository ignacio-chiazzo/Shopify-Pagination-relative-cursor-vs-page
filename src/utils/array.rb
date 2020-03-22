# frozen_string_literal: true

class Array
  def to_table
    return puts '||' if empty?

    column_sizes = reduce([]) do |lengths, row|
      row.each_with_index.map do |iterand, index|
        [lengths[index] || 0, iterand.to_s.length].max
      end
    end

    # print first row
    puts delimiter = Printable.print_delimiter_header(column_sizes)
    first_row = self[0]
    Printable.print_row(first_row, column_sizes)
    puts delimiter

    self[1..-1].each do |row|
      Printable.print_row(row, column_sizes)
    end

    puts delimiter
  end
end

class Printable
  class << self
    DELIMITER_COLUMN = ' | '
    DELIMITER_ROW    = '-'

    def print_row(row, column_sizes)
      row = row.fill(nil, row.size..(column_sizes.size - 1))
      row = row.each_with_index.map do |value, index|
        value.to_s + ' ' * (column_sizes[index] - value.to_s.length)
      end

      puts DELIMITER_COLUMN + row.join(DELIMITER_COLUMN) + DELIMITER_COLUMN
    end

    def print_delimiter_header(column_sizes)
      DELIMITER_ROW * (column_sizes.inject(&:+) + (3 * column_sizes.count) + 1)
    end
  end
end
