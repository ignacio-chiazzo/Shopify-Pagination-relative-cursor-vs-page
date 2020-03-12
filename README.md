# Shopify-Pagination-relative-cursor-vs-page
Compare Shopify REST Admin API using Relative Cursor vs Page based pagination. 

### Prerequisites: 
You need to install the `shopify_api` gem. You can run in the console `gem install shopify_api`

You need two things a shop domain and an `access_token`. You can read [this doc](https://github.com/Shopify/shopify_api#3-requesting-access-from-a-shop) to see how can you generate that token. 

### Getting started.

1) Go to the file `ruby api_pagination_benchmark.rb` and modify the variables `DOMAIN` and `ACCESS_TOKEN`.
2) Then run this file `ruby api_pagination_benchmark.rb`

This will iterate over all of your products, one using Page based pagination and other using Cursor based pagination and post some metrics. See image below:


### Changing params

You can play around and change the class variables Model if you want to iterate over other resource (e.g. `Collection`, or `Order`), or the size of each page by changing the `LIMIT` variable. 
