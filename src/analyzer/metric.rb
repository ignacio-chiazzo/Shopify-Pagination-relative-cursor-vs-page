class Metric
  def initialize
    @total_pages = 0
    @total_records = 0
    @time_itaring_using_page = 0
    @time_iterating_using_cursor_based_pagination = 0
  end

  attr_accessor :total_records, :total_pages, :time_iterating_using_cursor_based_pagination, :time_itaring_using_page
end
