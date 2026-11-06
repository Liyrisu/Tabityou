names = ["旅行太郎", "旅子花子", "山田太郎", "佐藤花子", "鈴木一郎", "高橋美咲"]
locations = ["東京", "京都", "大阪", "北海道", "沖縄", "鎌倉", "軽井沢", "広島"]
diary_bodies = [
  "美しい景色をたくさん見ることができました。",
  "おすすめスポットで楽しい時間を過ごしました。",
  "地元の食事を味わい、旅の思い出になりました。",
  "天気に恵まれて、予定通り観光できました。"
]

10.times do
  User.create!(
    name: "#{names.sample}#{rand(1000)}",
    email: "user_#{SecureRandom.hex(6)}@example.com",
    password: "password",
    password_confirmation: "password"
  )
end

20.times do
  user = User.order("RANDOM()").first
  location = locations.sample
  date = rand(365).days.ago.to_date

  plan = user.plans.create!(
    date: date,
    location: location,
    comment: "#{location}での旅行プランです。"
  )

  user.diaries.create!(
    plan: plan,
    date: date,
    location: location,
    comment: diary_bodies.sample
  )
end
