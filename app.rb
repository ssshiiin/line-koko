# app.rb
require 'sinatra'
require 'line/bot'
require 'dotenv'
require 'google/apis/customsearch_v1'
Dotenv.load ".env"

def client
    @client ||= Line::Bot::Client.new { |config|
        config.channel_id = ENV["LINE_CHANNEL_ID"]
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
end

def getImageUrl(query)
    searcher = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
    searcher.key = ENV["CUSTOM_SEARCH_API"]


    results = searcher.list_cses(q: query, cx: CSE_ID, search_type: "image", num: 1, sort: "review-rating:d:s,review-pricerange:d:w")
    items = results.items
    items.first.link
end

def command?(message)
    message.split(/[[:blank:]]/)[0] == 'ココ'
end

def search_image?(search_word)
    google_image_scraper search_word 1
end

post '/callback' do
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
        error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)
    events.each do |event|
        return "not message" unless event.is_a?(Line::Bot::Event::Message)
        return "not text" unless event.type === Line::Bot::Event::MessageType::Text
        return "not command" unless command?(event.message['text'])

        search_result = getImageUrl('長岡花火')

        image = {
            "type": "image",
            "originalContentUrl": search_result,
            "previewImageUrl": search_result
        }
        client.reply_message(event['replyToken'], image)
    end
    "OK"
end
# ====== 追記ここまで ======
get '/' do
    "Hello wolrd!"
end