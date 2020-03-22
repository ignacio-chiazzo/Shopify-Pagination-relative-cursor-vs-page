# frozen_string_literal: true

require_relative '../benchmark_printer'
require_relative '../constants'
require_relative '../analyzer/analyzer'

class Paginate
  extend Constants

  def initialize(domain:, access_token:)
    @shopify_session = ShopifyAPI::Session.new(
      domain: domain, token: access_token, api_version: @api_version, extra: nil
    )
    @limit = Constants::LIMIT_PER_PAGE
  end

  def paginate(_model)
    ShopifyAPI::Base.activate_session(@shopify_session)
  end

  protected

  def benchmark_pagination(model, &block)
    puts start_message_pagination(model)
    BenchmarkPrinter.benchmark_time(final_message_time(model), highlight_number: true, &block)
  end

  def benchmark_page(model, page, &block)
    result, duration_ms = BenchmarkPrinter.benchmark_time(message_querying_page(model, page), &block)
    total_current_page = result.size
    @analizyer = Analyzer.instance.add_metric(model, page, total_current_page, duration_ms, self.class)
    result
  end

  def start_message_pagination(_model)
    raise NotImplementedError
  end

  def final_message_time(_model)
    raise NotImplementedError
  end

  def message_querying_page(_model, _page)
    raise NotImplementedError
  end
end
