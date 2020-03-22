# frozen_string_literal: true

class Array
  def to_table
    return puts "||"  if self.empty?

    column_sizes = self.reduce([]) do |lengths, row|
      row.each_with_index.map{|iterand, index| [lengths[index] || 0, iterand.to_s.length].max}
    end

    # print first row
    puts head = '-' * (column_sizes.inject(&:+) + (3 * column_sizes.count) + 1)
    first_row = self[0]
    print_row(first_row, column_sizes)
    puts head

    self[1..-1].each do |row|
      print_row(row, column_sizes)
    end
    puts head
  end

  private

  def print_row(row, column_sizes)
    row = row.fill(nil, row.size..(column_sizes.size - 1))
    row = row.each_with_index.map{|v, i| v = v.to_s + ' ' * (column_sizes[i] - v.to_s.length)}
    puts '| ' + row.join(' | ') + ' |'
  end
end
