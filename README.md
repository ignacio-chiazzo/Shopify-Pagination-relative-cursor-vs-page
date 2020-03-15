# Shopify-Pagination-relative-cursor-vs-page
Compare Shopify REST Admin API using Relative Cursor vs Page based pagination. 

[Shopify Released Cursor-based pagination](https://shopify.dev/tutorials/make-paginated-requests-to-rest-admin-api) in version `2019-07`, this script compares this new approach with the old one (using page based pagination).

### Prerequisites: 
You need to install the `shopify_api` gem. You can run in the console `gem install shopify_api`

You need two things, a `shop` domain and an `access_token`. You can read [this doc](https://github.com/Shopify/shopify_api#3-requesting-access-from-a-shop) to see how can you generate that token. 

### Getting started.

1) Go to the file `src/constants.rb` and modify the variables `DOMAIN` and `ACCESS_TOKEN`.
2) Then run the file `ruby api_pagination_benchmark.rb`

This will iterate over all sets (defined in `PaginatedModels`) twice, one using **Page based pagination** and other using **Cursor based pagination** and post some metrics. See image below:

<img src="https://github.com/ignacio-chiazzo/Shopify-Pagination-relative-cursor-vs-page/blob/master/cursor_based_pagination_vs_page_based_pagination.png?raw=true">

### Changing params

You can play around and change the class variables in the file `src/constants.rb`. If you want to add or modify which resources it will iterate(e.g. `Collection`, or `Order`), you need to modify the file `src/paginated_models.rb`

### Notes

Some of the endpoints are using some kind of cache so trying running the script multiple times might retrieve similar numbers. You can see a big difference in the very first run 

