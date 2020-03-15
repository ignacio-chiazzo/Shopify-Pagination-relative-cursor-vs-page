

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
  LIMIT_PER_PAGE = 50
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

class PageBasedPaginate
  extend Constants
  extend BenchmarkPrinter

  def initialize
    @api_version = Constants::API_VERSION_USING_PAGE
    @shopify_session = ShopifyAPI::Session.new(domain: Constants::DOMAIN, token: Constants::ACCESS_TOKEN, api_version: @api_version, extra: nil)
    @limit = Constants::LIMIT_PER_PAGE
  end

  def test_using_page(model)
    ShopifyAPI::Base.activate_session(@shopify_session)
    page = 1
    self.class.benchmark_time(final_message_time(model)) do # TODO: check class
      records = query_records_using_page(model, page)
      while(records.count == @limit)
        page += 1
        records = query_records_using_page(model, page)
      end
    end
  end

  private

  def query_records_using_page(model, page)
    self.class.benchmark_time(message(model, page)) do
      model.find(:all, params: { limit: @limit, page: page })
    end
  end

  def message(model, page)
    "Time to get page #{page} for #{model}s  USING PAGE : "
  end

  def final_message_time(model)
    "\e[31m Time to iterate over all #{model}s using PAGE: \e[0m"
  end
end

class CurosrBasedPaginate
  extend Constants
  extend BenchmarkPrinter

  def initialize
    @api_version = Constants::API_VERSION_USING_CURSOR_RELATIVE
    @shopify_session = ShopifyAPI::Session.new(domain: Constants::DOMAIN, token: Constants::ACCESS_TOKEN, api_version: @api_version, extra: nil)
    @limit = Constants::LIMIT_PER_PAGE
  end

  def test_using_cursor_based_paginator(model)
    ShopifyAPI::Base.activate_session(@shopify_session)

    page = 1
    self.class.benchmark_time(final_message_time(model)) do
      records = self.class.benchmark_time(message(model, page)) do
        model.find(:all, params: { limit: @limit })
      end
      while records.next_page?
        page += 1
        records = self.class.benchmark_time(message(model, page)) do
          records.fetch_next_page
        end
      end
    end
  end

  private

  def message(model, page)
    "Time to get page #{page} for #{model}s USING CURSOR BASED PAGINATION: "
  end

  def final_message_time(model)
    "\e[32m Time to iterate over all #{model}s using CURSOR BASED PAGINATION: \e[0m"
  end
end

paged_based_paginate = PageBasedPaginate.new
paged_based_paginate.test_using_page(ShopifyAPI::Product)

cursor_based_paginate = CurosrBasedPaginate.new
cursor_based_paginate.test_using_cursor_based_paginator(ShopifyAPI::Product)