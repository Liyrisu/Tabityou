require "rails_helper"

RSpec.describe Diary, type: :model do
  # 記録バリデーション機能: 記録に必要な項目を検証する
  describe "記録バリデーション機能" do
    it "有効な属性なら記録を作成できる" do
      expect(build(:diary)).to be_valid
    end

    it "コメントが空なら記録を作成できない" do
      diary = build(:diary, comment: "")
      expect(diary).not_to be_valid
      expect(diary.errors[:comment]).to be_present
    end

    it "場所が空なら記録を作成できない" do
      diary = build(:diary, location: "")
      expect(diary).not_to be_valid
      expect(diary.errors[:location]).to be_present
    end

    it "日付が空なら記録を作成できない" do
      diary = build(:diary, date: nil)
      expect(diary).not_to be_valid
      expect(diary.errors[:date]).to be_present
    end
  end
end
