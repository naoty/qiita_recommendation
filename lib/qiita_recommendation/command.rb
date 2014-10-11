require "thor"

module QiitaRecommendation
  class Command < Thor
    desc "users YOUR_ID", "Recommend users similar to YOUR_ID"
    def users(user_id)
      if ENV["ACCESS_TOKEN"] == nil
        raise Thor::Error.new("ERROR: You must specify your access token at environmental variable named ACCESS_TOKEN.")
      end

      crawler = Crawler.new(access_token: ENV["ACCESS_TOKEN"])
      dataset = crawler.crawl_dataset_based_on_users(user_id: user_id)

      recommendation_engine = RecommendationEngine.new(dataset)
      similar_users = recommendation_engine.top_matched_users(user_id: user_id)
      similar_users.each_pair { |user, score| puts "#{user}: #{score}" }
    end
  end
end