# frozen_string_literal: true

class Metric
  def initialize
    @total_pages = 0
    @total_records = 0
    @time_itaring_using_page = 0
    @time_iterating_using_cursor_based_pagination = 0
    @percentage_of_improvement = 0
  end

  attr_accessor :total_records, :total_pages, :percentage_of_improvement

  def time_itaring_using_page
    @time_itaring_using_page
  end

  def time_itaring_using_page=(value)
    @time_itaring_using_page = value
    recalculate_percentage_of_improvement
  end

  def time_iterating_using_cursor_based_pagination
    @time_iterating_using_cursor_based_pagination
  end

  def time_iterating_using_cursor_based_pagination=(value)
    @time_iterating_using_cursor_based_pagination = value
    recalculate_percentage_of_improvement
  end

  private

  def recalculate_percentage_of_improvement
    percentage_when_iterating_using_page = (@time_iterating_using_cursor_based_pagination * 100) / @time_itaring_using_page
    @percentage_of_improvement = (100 - percentage_when_iterating_using_page).round(2)
  end
end
