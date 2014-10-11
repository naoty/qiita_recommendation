module QiitaRecommendation
  class RecommendationEngine
    def initialize(dataset)
      @dataset = dataset
    end

    def top_matched_users(user_id: "", count: 5)
      user_ids = @dataset.key
      user_ids.delete(user_id)
      ranked_users = user_ids.map do |another_user_id|
        [pearson_coefficient(user_id1: user_id, user_id2: another_user_id), another_user_id]
      end
      ranked_users.sort.reverse.take(count)
    end

    private

    def pearson_coefficient(user_id1: "", user_id2: "")
      item_ids = @dataset[user_id1].keys
      return 0 if item_ids.count == 0

      sum1 = @dataset[user_id1].values.reduce(&:+)
      sum2 = @dataset[user_id2].values.reduce(&:+)

      square_sum1 = @dataset[user_id1].values.reduce(0) { |result, value| result += value ** 2 }
      square_sum2 = @dataset[user_id2].values.reduce(0) { |result, value| result += value ** 2 }

      product_sum = item_ids.reduce(0) do |result, item_id|
        result += @dataset[user_id1][item_id] * @dataset[user_id2][item_id]
      end

      number = product_sum - (sum1 * sum2 / item_ids.count)
      den = Math.sqrt((square_sum1 - sum1 ** 2 / item_ids.count) * (square_sum2 - sum2 ** 2 / item_ids.count))

      return den == 0 ? 0 : number / den
    end
  end
end