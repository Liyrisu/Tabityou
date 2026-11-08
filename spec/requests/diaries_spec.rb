require "rails_helper"

RSpec.describe "記録（Diary）機能", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  def log_in(user)
    post login_path, params: { email: user.email, password: "password123" }
  end

  # 記録一覧表示機能: ログイン状態で一覧を表示する
  describe "GET /diaries - 記録一覧表示機能" do
    it "ログインユーザーの一覧画面を表示する" do
      log_in(user)
      create(:diary, user: user, location: "京都")

      get diaries_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("京都")
    end

    # 記録一覧表示機能: 他ユーザーの記録は一覧に表示しない
    it "自分以外の記録は一覧に表示しない" do
      log_in(user)
      create(:diary, user: user, location: "自分の旅行先")
      create(:diary, user: other_user, location: "他人の旅行先")

      get diaries_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("自分の旅行先")
      expect(response.body).not_to include("他人の旅行先")
    end

    it "未ログイン時はログイン画面へリダイレクトする" do
      get diaries_path
      expect(response).to redirect_to(login_path)
    end
  end

  # 記録詳細表示機能: 指定した記録の詳細を表示する
  describe "GET /diaries/:id - 記録詳細表示機能" do
    it "指定した記録の詳細を表示する" do
      log_in(user)
      diary = create(:diary, user: user, comment: "詳細テストの本文")

      get diary_path(diary)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("詳細テストの本文")
    end
  end

  # 記録作成機能: 有効な入力で記録を作成する
  describe "POST /diaries - 記録作成機能" do
    before { log_in(user) }

    it "有効な入力なら記録を作成して一覧へ遷移する" do
      expect {
        post diaries_path, params: {
          diary: { date: Date.current, location: "大阪", comment: "大阪旅行" }
        }
      }.to change(Diary, :count).by(1)

      expect(response).to redirect_to(diaries_path)
      expect(Diary.last.user).to eq(user)
    end

    it "必須項目が空なら作成せず入力画面を再表示する" do
      expect {
        post diaries_path, params: { diary: { date: nil, location: "", comment: "" } }
      }.not_to change(Diary, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  # 記録編集機能: 当該記録作成者のみ記録を更新できる
  describe "GET /diaries/:id/edit and PATCH /diaries/:id - 記録編集機能" do
    it "編集画面を表示する" do
      log_in(user)
      diary = create(:diary, user: user)

      get edit_diary_path(diary)

      expect(response).to have_http_status(:ok)
    end

    it "当該記録作成者は記録を更新できる" do
      log_in(user)
      diary = create(:diary, user: user)

      patch diary_path(diary), params: {
        diary: { location: "札幌", comment: "更新後の本文", date: Date.current }
      }

      expect(response).to redirect_to(diary_path(diary))
      expect(diary.reload.location).to eq("札幌")
      expect(diary.comment).to eq("更新後の本文")
    end

    it "無効な入力なら更新せず編集画面を再表示する" do
      log_in(user)
      diary = create(:diary, user: user)

      patch diary_path(diary), params: { diary: { location: "", comment: "", date: nil } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(diary.reload.location).to eq("東京")
    end

    it "他ユーザーの記録は編集できない" do
      log_in(other_user)
      diary = create(:diary, user: user)

      patch diary_path(diary), params: { diary: { location: "北海道" } }

      expect(response).to have_http_status(:not_found)
      expect(diary.reload.location).to eq("東京")
    end
  end

  # 記録削除機能: 当該記録作成者のみ記録を削除できる
  describe "DELETE /diaries/:id - 記録削除機能" do
    it "当該記録作成者は記録を削除できる" do
      log_in(user)
      diary = create(:diary, user: user)

      expect {
        delete diary_path(diary)
      }.to change(Diary, :count).by(-1)

      expect(response).to redirect_to(diaries_path)
      expect(response).to have_http_status(:see_other)
    end

    it "他ユーザーの記録は削除できない" do
      log_in(other_user)
      diary = create(:diary, user: user)

      delete diary_path(diary)

      expect(response).to have_http_status(:not_found)
      expect(Diary.exists?(diary.id)).to be(true)
    end
  end
end
