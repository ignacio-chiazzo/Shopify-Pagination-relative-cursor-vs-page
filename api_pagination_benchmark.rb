

# Prerequisites: You need to install the shopify_api gem. You can run in the console `gem install shopify_api`
# You need to put a DOMAIN and ACCESS_TOKEN variables in the src/constants file. Then run this file in the console (`ruby api_pagination_benchmark.rb`)

require_relative 'src/paginated_models'
require_relative 'src/pagination/cursor_based_paginate'
require_relative 'src/pagination/page_based_paginate'

class TestPagination
  def initialize(models: PaginatedModels::MODELS)
    @models = models
    @page_based_paginate = PageBasedPaginate.new
    @cursor_based_paginate = CursorBasedPaginate.new
  end

  def paginate_and_benchmark
    @models.each do |model|
      @page_based_paginate.paginate(model)
      @cursor_based_paginate.paginate(model)
    end
    analyzer = Analyzer.instance
    analyzer.print_stats
  end
end

test_pagination = TestPagination.new
test_pagination.paginate_and_benchmark