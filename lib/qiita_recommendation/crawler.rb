require "qiita"

module QiitaRecommendation
  class Crawler
    def initialize(access_token: "")
      @client = Qiita::Client.new(access_token: access_token)
    end

    def crawl_dataset_based_on_users(user_id: "")
      dataset = {}
      dataset[user_id] = {}

      item_ids = []

      my_stocked_items = @client.list_user_stocks(user_id).body
      my_stocked_items.each do |my_item|
        my_item_id = my_item["id"]
        dataset[user_id][my_item_id] = 1
        item_ids << my_item_id

        stockers = @client.list_item_stockers(my_item_id).body
        stockers.each do |stocker|
          stocker_id = stocker["id"]
          dataset[stocker_id] ||= {}
          stocker_stocked_items = @client.list_user_stocks(stocker_id).body
          stocker_stocked_items.each do |stocker_item|
            dataset[stocker_id][stocker_item["id"]] = 1
            item_ids << stocker_item["id"]
          end
          sleep 10
        end
        sleep 10
      end

      item_ids.uniq!
      dataset.each_pair do |user_id, items|
        item_ids.each { |item_id| items[item_id] ||= 0 }
      end

      dataset
    end
  end
end