# frozen_string_literal: true

require_relative 'src/test_pagination'

test_pagination = TestPagination.new
test_pagination.paginate_and_benchmark
