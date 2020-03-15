require_relative '../string'
require_relative '../constants'
require_relative '../paginated_models'
require_relative 'paginate'

class CursorBasedPaginate < Paginate
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
    String.green("---------->  Time to iterate over all #{model.name}s using CURSOR BASED PAGINATION:")
  end

  def start_message_pagination(model)
    String.blue("Start to Paginate #{String.bg_gray(model.name)} USING CURSOR BASED PAGINATION")
  end
end
