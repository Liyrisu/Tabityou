require "rails_helper"

RSpec.describe User, type: :model do
  # ユーザー登録バリデーション: 必須項目と形式を検証する
  describe "ユーザー登録バリデーション" do
    it "有効な属性なら登録できる" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "名前が空なら登録できない" do
      user = build(:user, name: "")
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end

    it "メールアドレスが重複していると登録できない" do
      create(:user, email: "duplicate@example.com")
      user = build(:user, email: "duplicate@example.com")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "パスワードが8文字未満なら登録できない" do
      user = build(:user, password: "short", password_confirmation: "short")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end
  end

  # ユーザー所有判定機能: 記録の所有者か判定する
  describe "ユーザー所有判定機能 (#own?)" do
    it "自分が所有する記録なら true を返す" do
      user = create(:user)
      diary = create(:diary, user: user)
      expect(user.own?(diary)).to be(true)
    end

    it "他ユーザーの記録なら false を返す" do
      user = create(:user)
      other_user = create(:user)
      diary = create(:diary, user: other_user)
      expect(user.own?(diary)).to be(false)
    end
  end
end
