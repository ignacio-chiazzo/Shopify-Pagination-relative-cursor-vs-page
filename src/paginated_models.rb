# frozen_string_literal: true

require 'shopify_api'

Model = Struct.new(:name, :klass)

class PaginatedModels
  MODELS = [
    Model.new('customers', ShopifyAPI::Customer),
    Model.new('smart_collections', ShopifyAPI::SmartCollection),
    Model.new('custom_collections', ShopifyAPI::CustomCollection),
    Model.new('collects', ShopifyAPI::Collect),
    Model.new('products', ShopifyAPI::Product),
    Model.new('orders', ShopifyAPI::Order)
  ].freeze
end
