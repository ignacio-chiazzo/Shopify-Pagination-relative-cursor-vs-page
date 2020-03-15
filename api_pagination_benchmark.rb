

# Shopify

# Instructions
# Prerequisites: You need to install the shopify_api gem. You can run in the console `gem install shopify_api`

# You need to put a DOMAIN and ACCESS_TOKEN variables. Then run this file in the console (`ruby api_pagination_benchmark.rb`) which will call two functions
# BenchmarkShopifyAPIPagination.test_using_page
# BenchmarkShopifyAPIPagination.test_using_cursor_based_paginator
#

require 'shopify_api'

module Constants
  DOMAIN = <YOUR-SHOP-DOMAIN> # e.g <shop>.myshopify.com
  ACCESS_TOKEN =  <YOUR-ACCESS-TOKEN> #Put your access token here. You can see the docs to see how can the info here https://github.com/Shopify/shopify_api#3-requesting-access-from-a-shop
  API_VERSION_USING_PAGE = '2019-04'
  API_VERSION_USING_CURSOR_RELATIVE = '2019-10'
  LIMIT_PER_PAGE = 100
end

module BenchmarkPrinter
  def benchmark_time(message, &block)
    time = Time.now.utc
    begin
      yield
    ensure
      duration_ms = (Time.now.utc - time) * 1000
      puts "#{message} #{duration_ms.round(2)} ms \n"
    end
  end
end

Model = Struct.new(:name, :klass)

class PaginatedModels
  MODELS = [
    Model.new("customers", ShopifyAPI::Customer),
    Model.new("smart_collections", ShopifyAPI::SmartCollection),
    Model.new("custom_collections", ShopifyAPI::CustomCollection),
    Model.new("collects", ShopifyAPI::Collect),
    Model.new("products", ShopifyAPI::Product),
    Model.new("orders", ShopifyAPI::Order)
  ].freeze
end

class TestPagination
  def initialize(models: PaginatedModels::MODELS)
    @models = models
    @paged_based_paginate = PageBasedPaginate.new
    @cursor_based_paginate = CurosrBasedPaginate.new
  end

  def paginate_and_benchmark
    @models.each do |model|
      @paged_based_paginate.paginate(model)
      @cursor_based_paginate.paginate(model)
    end
  end
end

class Color
  class << self
    def blue(message)
      "\e[34m#{message}\e[0m"
    end

    def red(message)
      "\e[31m#{message}\e[0m"
    end

    def green(message)
      "\e[32m#{message}\e[0m"
    end

    def bg_gray(message)
      "\e[47m#{message}\e[0m"
    end
  end
end

class Paginate
  extend Constants
  extend BenchmarkPrinter

  def initialize
    @shopify_session = ShopifyAPI::Session.new(domain: Constants::DOMAIN, token: Constants::ACCESS_TOKEN, api_version: @api_version, extra: nil)
    @limit = Constants::LIMIT_PER_PAGE
  end

  def paginate
    raise NotImplementedError
  end

  protected

  def benchmark_pagination(model, &block)
    puts start_message_pagination(model)
    self.class.benchmark_time(final_message_time(model), &block)
  end

  def benchmark_page(model, page, &block)
    self.class.benchmark_time(message_querying_page(model, page), &block)
  end

  def start_message_pagination(model)
    raise NotImplementedError
  end

  def final_message_time(model)
    raise NotImplementedError
  end

  def message_querying_page(model, page)
    raise NotImplementedError
  end
end


class PageBasedPaginate < Paginate
  def initialize
    @api_version = Constants::API_VERSION_USING_PAGE
    super
  end

  def paginate(model)
    ShopifyAPI::Base.activate_session(@shopify_session)
    klass = model.klass

    page = 1
    benchmark_pagination(model) do
      records = query_records_using_page(klass, page)
      while(records.count == @limit)
        page += 1
        records = query_records_using_page(klass, page)
      end
    end
  end

  protected

  def message_querying_page(model, page)
    "Time to get page #{page} for #{model.name} USING PAGE : "
  end

  def start_message_pagination(model)
    Color.blue("Start to Paginating #{Color.bg_gray(model.name)} USING PAGE")
  end

  def final_message_time(model)
    Color.red("Time to iterate over all #{model.name} using PAGE:")
  end

  private

  def query_records_using_page(klass, page)
    benchmark_page(klass, page) do
      klass.find(:all, params: { limit: @limit, page: page })
    end
  end
end

class CurosrBasedPaginate < Paginate
  def initialize
    @api_version = Constants::API_VERSION_USING_CURSOR_RELATIVE
    super
  end

  def paginate(model)
    ShopifyAPI::Base.activate_session(@shopify_session)

    page = 1
    klass = model.klass
    benchmark_pagination(model) do
      records = benchmark_page(klass, page) do
        klass.find(:all, params: { limit: @limit })
      end
      while records.next_page?
        page += 1
        records = benchmark_page(klass, page) do
          records.fetch_next_page
        end
      end
    end
  end

  protected

  def message_querying_page(model, page)
    "Time to get page #{page} for #{model.name} USING CURSOR BASED PAGINATION: "
  end

  def final_message_time(model)
    Color.green("Time to iterate over all #{model}s using CURSOR BASED PAGINATION:")
  end

  def start_message_pagination(model)
    Color.blue("Start to Paginating #{Color.bg_gray(model.name)} USING CURSOR BASED PAGINATION")
  end
end

test_pagination = TestPagination.new
test_pagination.paginate_and_benchmark