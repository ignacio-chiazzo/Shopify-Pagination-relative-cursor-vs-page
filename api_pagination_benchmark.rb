

# Prerequisites: You need to install the shopify_api gem. You can run in the console `gem install shopify_api`
# You need to put a DOMAIN and ACCESS_TOKEN variables in the src/constants file. Then run this file in the console (`ruby api_pagination_benchmark.rb`)

require_relative 'src/test_pagination'

test_pagination = TestPagination.new
test_pagination.paginate_and_benchmark