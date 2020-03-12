

# Shopify

# Instructions
# Prerequisites: You need to install the shopify_api gem. You can run in the console `gem install shopify_api`

# You need to put a DOMAIN and ACCESS_TOKEN variables. Then run this file in the console (`ruby api_pagination_benchmark.rb`) which will call two functions
# BenchmarkShopifyAPIPagination.test_using_page
# BenchmarkShopifyAPIPagination.test_using_cursor_based_paginator
#

require 'shopify_api'

class BenchmarkShopifyAPIPagination
  DOMAIN = <YOUR-SHOP-DOMAIN> # e.g <shop>.myshopify.com
  ACCESS_TOKEN =  <YOUR-ACCESS-TOKEN> #Put your access token here. You can see the docs to see how can the info here https://github.com/Shopify/shopify_api#3-requesting-access-from-a-shop
  API_VERSION_USING_PAGE = '2019-04'
  API_VERSION_USING_CURSOR_RELATIVE = '2019-10'
  LIMIT_PER_PAGE = 50
  MODEL = ShopifyAPI::Product # You can change this value to any other class that has an index and a count action such as `ShopifyAPI::Customer, ShopifyAPI::Order, ShopifyAPI::Collect, ShopifyAPI::SmartCollection, ShopifyAPI::CustomCollection`

  class << self
    def test_using_page
      api_version = API_VERSION_USING_PAGE
      authenticate(api_version: api_version)

      page = 1
      benchmark_time(final_message_time(api_version)) do
        records = query_records_using_page(page)
        while(records.count == LIMIT_PER_PAGE)
          page += 1
          records = query_records_using_page(page)
        end
      end
    end

    def test_using_cursor_based_paginator
      api_version = API_VERSION_USING_CURSOR_RELATIVE
      authenticate(api_version: api_version)

      page = 1
      benchmark_time(final_message_time(api_version)) do
        records = benchmark_time(message_for_query(api_version, page)) do
          MODEL.find(:all, params: { limit: LIMIT_PER_PAGE })
        end
        while records.next_page?
          page += 1
          records = benchmark_time(message_for_query(api_version, page)) do
            records.fetch_next_page
          end
        end
      end
    end

    private

    def message_for_query(api_version, page)
      if api_version == API_VERSION_USING_CURSOR_RELATIVE
        "Time to get page #{page} for #{MODEL.name.demodulize} USING CURSOR BASED PAGINATION: "
      elsif api_version == API_VERSION_USING_PAGE
        "Time to get page #{page} for #{MODEL.name.demodulize}  USING PAGE : "
      end
    end

    def final_message_time(api_version)
      if api_version == API_VERSION_USING_CURSOR_RELATIVE
        "\e[32m Time to iterate over all #{MODEL.name.demodulize} using CURSOR BASED PAGINATION: \e[0m"
      elsif api_version == API_VERSION_USING_PAGE
        "\e[31m Time to iterate over all #{MODEL.name.demodulize} using PAGE: \e[0m"
      end
    end

    def query_records_using_page(page)
      benchmark_time(message_for_query(API_VERSION_USING_PAGE, page)) do
        MODEL.find(:all, params: { limit: LIMIT_PER_PAGE, page: page })
      end
    end

    def authenticate(api_version:)
      shopify_session = ShopifyAPI::Session.new(domain: DOMAIN, token: ACCESS_TOKEN, api_version: api_version, extra: nil)
      ShopifyAPI::Base.activate_session(shopify_session)
    end

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
end

BenchmarkShopifyAPIPagination.test_using_page
BenchmarkShopifyAPIPagination.test_using_cursor_based_paginator
