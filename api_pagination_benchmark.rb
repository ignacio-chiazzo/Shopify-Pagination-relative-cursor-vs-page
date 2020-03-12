# Shopify

# Instructions
# Prerequisites: You need to install the shopify_api gem. You can run in the console `gem install shopify_api`

# You need to put a DOMAIN and ACCESS_TOKEN variables. Then run this file in the console (`ruby api_pagination_benchmark.rb`) which will call two functions
# BenchmarkShopifyAPIPagination.test_using_page
# BenchmarkShopifyAPIPagination.test_using_cursor_based_paginator
#

require 'shopify_api'

class BenchmarkShopifyAPIPagination
  DOMAIN = <YOUR-SHOP-DOMAIN> # Put your shop domain here e.g <shop>.myshopify.com
  ACCESS_TOKEN = <YOUR-ACCESS-TOKEN> # Put your access token here. You can see the docs to see how can the info here https://github.com/Shopify/shopify_api#3-requesting-access-from-a-shop
  API_VERSION_USING_PAGE = '2019-04'
  API_VERSION_USING_CURSOR_RELATIVE = '2019-10'
  LIMIT_PER_PAGE = 50

  class << self
    def test_using_page
      authenticate(api_version: API_VERSION_USING_PAGE)
      page = 1
      benchmark_time("\e[31m Time to iterate over all products USING PAGE: \e[0m") do
        products = query_products_using_page(page)
        while(products.count == LIMIT_PER_PAGE)
          page += 1
          products = query_products_using_page(page)
        end
      end
    end

    def test_using_cursor_based_paginator
      authenticate(api_version: API_VERSION_USING_CURSOR_RELATIVE)
      benchmark_time("\e[32m Time to iterate over all products using USING CURSOR BASED PAGINATION: \e[0m") do
        page = 1
        products = benchmark_time("Time to get page 1 USING CURSOR BASED PAGINATION: ") do
          ShopifyAPI::Product.find(:all, params: { limit: LIMIT_PER_PAGE })
        end
        while products.next_page?
          page += 1
          products = benchmark_time("Time to get page #{page} USING CURSOR BASED PAGINATION: ") do
            products.fetch_next_page
          end
        end
      end
    end

    private

    def query_products_using_page(page)
      benchmark_time("Time to get page #{page} USING PAGE : ") do
        ShopifyAPI::Product.find(:all, params: { limit: LIMIT_PER_PAGE, page: page })
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
