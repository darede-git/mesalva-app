# frozen_string_literal: true

class V2::PrepTestSerializer
  include FastJsonapi::ObjectSerializer

  attributes :cnat_min_score, :cnat_average_score, :cnat_max_score,
             :chum_min_score, :chum_average_score, :chum_max_score,
             :ling_esp_min_score, :ling_esp_average_score, :ling_esp_max_score,
             :ling_ing_min_score, :ling_ing_average_score, :ling_ing_max_score,
             :mat_min_score, :mat_average_score, :mat_max_score
end
