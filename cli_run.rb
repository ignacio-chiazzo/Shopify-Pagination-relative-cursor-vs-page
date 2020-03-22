# frozen_string_literal: true

require_relative 'src/test_pagination'
require_relative 'src/utils/string'

class CLI
  YES = %w[Yes yes Y y].freeze

  def self.run
    loop do
      puts "To run the script in your shop you will need to enter the Shop Domain and the access Token.\n"

      puts String.blue('Enter the shop DOMAIN: e.g. example.myshopify.com')
      domain = gets.chomp

      puts String.blue('Enter your access token')
      access_token = gets.chomp

      test_pagination = ::TestPagination.new(domain: domain, access_token: access_token)
      test_pagination.paginate_and_benchmark

      puts 'Do you want to Try it again? (Yes/No)'
      input = gets.chomp&.downcase

      break unless YES.include?(input)
    end
  end
end

CLI.run
