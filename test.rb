require 'dotenv'
require 'google/apis/customsearch_v1'
Dotenv.load ".env"

def search_image_url(query)
    searcher = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
    searcher.key = ENV["CUSTOM_SEARCH_API"]


    results = searcher.list_cses(q: query, cx: ENV["SEARCH_ENGINE"], search_type: "image", num: 1, sort: "review-rating:d:s,review-pricerange:d:w")
    items = results.items
    items.first.link
end

p search_image_url("花火")