require_relative '../utils/array'
require_relative 'metric'

class Analyzer
  include Singleton

  def initialize
    @metrics = {}
  end

  def add_model(model)
    @metrics[model.name] = Metric.new
  end

  def add_metric(model, page, total_current_page, duration_ms, klass)
    add_model(model) unless @metrics.key?(model.name)
    @metrics[model.name].total_pages = page
    @metrics[model.name].total_records = (Constants::LIMIT_PER_PAGE * (page - 1)) + total_current_page

    if klass == CursorBasedPaginate
      @metrics[model.name].time_iterating_using_cursor_based_pagination = (@metrics[model.name].time_iterating_using_cursor_based_pagination + duration_ms).round(2)
    elsif klass == PageBasedPaginate
      @metrics[model.name].time_itaring_using_page = (@metrics[model.name].time_itaring_using_page + duration_ms).round(2)
    end
  end

  def print_stats
    headers = ["Model", "Total Pages", "Total Records", "Time iterating using Page", "Time iterating using Cursor Based Pagination", "Percentage of Improvement"]
    table = [headers]
    @metrics.keys.each do |key|
      metric = @metrics[key]
      percentage_of_improvement = "#{metric.percentage_of_improvement}%"
      table << [
        key, metric.total_pages, metric.total_records, metric.time_itaring_using_page,
        metric.time_iterating_using_cursor_based_pagination, percentage_of_improvement
      ]
    end
    table.to_table
  end
end