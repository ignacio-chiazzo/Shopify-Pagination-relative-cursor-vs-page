# frozen_string_literal: true

require_relative 'paginated_models'
require_relative 'pagination/cursor_based_paginate'
require_relative 'pagination/page_based_paginate'

class TestPagination
  def initialize(
    models: PaginatedModels::MODELS, domain: Constants::DOMAIN,
    access_token: Constants::ACCESS_TOKEN
  )
    @models = models
    @page_based_paginate = PageBasedPaginate.new(domain: domain, access_token: access_token)
    @cursor_based_paginate = CursorBasedPaginate.new(domain: domain, access_token: access_token)
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
