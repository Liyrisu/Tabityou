FactoryBot.define do
  factory :diary do
    association :user
    date { Date.current }
    location { "東京" }
    comment { "楽しい旅行の記録です。" }
    image do
      Rack::Test::UploadedFile.new(Rails.root.join("public/icon.png"), "image/png")
    end
  end
end
