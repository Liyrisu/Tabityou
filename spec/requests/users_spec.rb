require "rails_helper"

RSpec.describe "ユーザー登録・ログイン機能", type: :request do
  # ユーザー登録機能: 新しいユーザーを作成する
  describe "POST /users - ユーザー登録機能" do
    it "有効な情報ならユーザーを登録してトップへ遷移する" do
      expect {
        post users_path, params: {
          user: {
            name: "新規ユーザー",
            email: "new@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
    end

    it "パスワード確認が一致しない場合は登録しない" do
      expect {
        post users_path, params: {
          user: {
            name: "新規ユーザー",
            email: "invalid@example.com",
            password: "password123",
            password_confirmation: "different123"
          }
        }
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "ヘッダーのナビゲーション" do
    let(:user) { create(:user) }

    it "ログイン中はロゴとマイページアイコンから記録一覧へ移動できる" do
      post login_path, params: { email: user.email, password: "password123" }
      get root_path

      document = Nokogiri::HTML(response.body)
      header_links = document.css("header a")
      logo_link = header_links.find { |link| link.at_css('img[alt="ロゴ"]') }
      my_page_link = header_links.find { |link| link.at_css('img[alt="マイページ"]') }

      expect(document.at_css("title").text).to eq("旅帖（たびちょう）")
      expect(logo_link["href"]).to eq(diaries_path)
      expect(my_page_link["href"]).to eq(diaries_path)
    end

    it "未ログイン時のマイページアイコンからログイン画面へ移動できる" do
      get root_path

      document = Nokogiri::HTML(response.body)
      header_links = document.css("header a")
      my_page_link = header_links.find { |link| link.at_css('img[alt="マイページ"]') }

      expect(my_page_link["href"]).to eq(login_path)
    end
  end

  # ユーザーログイン機能: メールアドレスとパスワードで認証する
  describe "POST /login - ユーザーログイン機能" do
    let(:user) { create(:user) }

    it "正しい認証情報ならログインして記録一覧へ遷移する" do
      post login_path, params: { email: user.email, password: "password123" }

      expect(response).to redirect_to(diaries_path)
      expect(session[:user_id]).to eq(user.id)
    end

    it "誤った認証情報ならログインを拒否する" do
      post login_path, params: { email: user.email, password: "wrong-password" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(session[:user_id]).to be_nil
    end
  end

  # ユーザーログアウト機能: セッションを終了する
  describe "DELETE /logout - ユーザーログアウト機能" do
    let(:user) { create(:user) }

    it "ログアウトするとセッションを削除してトップへ遷移する" do
      post login_path, params: { email: user.email, password: "password123" }
      delete logout_path

      expect(response).to redirect_to(root_path)
      expect(session[:user_id]).to be_nil
    end
  end
end
