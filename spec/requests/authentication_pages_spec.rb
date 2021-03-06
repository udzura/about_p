require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }
    let(:signin_button_selector) { ".btn_signin a[href='/auth/github']" }
    let(:create_user_text) { '登録する' }

    it { should have_selector(signin_button_selector) }

    context "ユーザを作成していない" do
      it "認証が通ったらユーザ作成画面が表示される" do
        find(signin_button_selector).click
        expect(page).to have_button(create_user_text)
      end

      it "ユーザ作成画面から一旦別のページに移動し、認証が必要なページに移動するとユーザ作成ページにリダイレクトする" do
        find(signin_button_selector).click
        visit 'http://www.yahoo.co.jp'
        visit users_path 
        expect(page).to have_button(create_user_text)
      end
    end

    context "ユーザを作成済みである" do
      before do
        @section = Section.create(name: "人材開発本部")
        @user = @section.users.create(name: "Keisuke KITA",
                                      irc_name: "kitak",
                                      github_uid: "12345",
                                      job_type: :engineer)
      end

      it "認証が通ったらユーザ一覧ページへ移動する" do
        find(signin_button_selector).click
        expect(page).to have_content('みんな') 
      end
    end

    context "not throught github authentication" do
      before { visit new_user_path }

      it { should have_selector(signin_button_selector) }
    end
  end
end
