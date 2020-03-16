require_relative '../utils/string'
require_relative '../constants'
require_relative '../paginated_models'
require_relative 'paginate'

class PageBasedPaginate < Paginate
  def initialize
    @api_version = Constants::API_VERSION_USING_PAGE
    super
  end

  def paginate(model)
    super

    page = 1
    benchmark_pagination(model) do
      records = query_records_using_page(model, page)
      while(records.count == @limit && page < Constants::MAX_PAGE)
        page += 1
        records = query_records_using_page(model, page)
      end
    end
  end

  protected

  def message_querying_page(model, page)
    "Time to get page #{page} for #{model.name} USING PAGE : "
  end

  def start_message_pagination(model)
    String.blue("Start to Paginate #{String.bg_gray(model.name)} USING PAGE")
  end

  def final_message_time(model)
    String.red("----------> Time to iterate over all #{model.name} using PAGE:")
  end

  private

  def query_records_using_page(model, page)
    benchmark_page(model, page) do
      model.klass.find(:all, params: { limit: @limit, page: page })
    end
  end
end