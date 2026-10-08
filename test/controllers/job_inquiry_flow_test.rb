require "test_helper"

class JobInquiryFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = Admin.create!(
      email: "admin-flow@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    @client = Client.create!(
      company: "株式会社テスト",
      person: "山田",
      tel: "0311112222",
      email: "owner@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    @other = Client.create!(
      company: "株式会社他社",
      person: "佐藤",
      tel: "0399998888",
      email: "other@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "ログインしていない人は会社の連絡先を見られない" do
    get clients_path
    assert_redirected_to new_admin_session_path
    follow_redirect!
    assert_no_match "0399998888", response.body

    get client_path(@other)
    assert_redirected_to new_client_session_path

    get client_jobs_path(@client)
    assert_redirected_to new_admin_session_path
  end

  test "クライアントは自分の連絡先だけ見られる" do
    sign_in @client
    get client_mypage_path
    assert_response :success
    assert_match "owner@example.com", response.body

    get client_path(@other)
    assert_redirected_to client_mypage_path
    follow_redirect!
    assert_no_match "0399998888", response.body
  end

  test "管理者は顧客一覧の連絡先を見られる" do
    sign_in @admin
    get clients_path
    assert_response :success
    assert_match "0399998888", response.body
    assert_match "株式会社他社", response.body
  end

  test "求人の問い合わせは顧客登録までで求人は作らない" do
    ActionMailer::Base.deliveries.clear
    assert_difference -> { Client.where(email: "newco@example.com").count }, 1 do
      assert_no_difference -> { Recruit.count } do
        post contracts_path, params: inquiry_params, headers: { "HTTP_REFERER" => "http://www.example.com/foreign-jobs" }
      end
    end

    assert_redirected_to "http://www.example.com/foreign-jobs?sent=1"
    client = Client.find_by!(email: "newco@example.com")
    assert_equal "株式会社新規", client.company
    assert_equal 0, client.recruits.count
    assert ActionMailer::Base.deliveries.none? { |mail| mail.subject.to_s.include?("パスワード設定") }
  end

  test "管理者だけがマイページ案内を送れる" do
    client = Client.new(
      company: "株式会社案内先",
      person: "案内",
      tel: "0312345678",
      email: "invite-target@example.com"
    )
    client.skip_password_validation = true
    client.save!

    ActionMailer::Base.deliveries.clear
    post send_portal_invite_client_path(client)
    assert_redirected_to new_admin_session_path

    sign_in @admin
    ActionMailer::Base.deliveries.clear
    post send_portal_invite_client_path(client)
    assert_redirected_to client_path(client)
    assert ActionMailer::Base.deliveries.any? { |mail| mail.subject.to_s.include?("パスワード設定") }
  end

  test "管理者は審査後に求人を公開できる" do
    recruit = Recruit.create!(
      title: "株式会社新規",
      client: @client,
      published: false
    )

    sign_in @admin
    post publish_recruit_path(recruit)
    assert_redirected_to client_path(recruit.reload.client)

    get recruits_path
    assert_response :success
    assert_match "株式会社新規", response.body
  end

  test "会社情報の再入力画面は問い合わせへ戻す" do
    get new_client_registration_path
    assert_redirected_to foreign_jobs_path
  end

  test "クライアントの求人登録は審査依頼になる" do
    sign_in @client
    get new_recruit_path
    assert_response :success
    assert_match "この内容で審査依頼する", response.body
    assert_no_match "この内容で保存する", response.body

    assert_difference -> { @client.recruits.count }, 1 do
      post recruits_path, params: { recruit: { title: "ホールスタッフ" } }
    end

    recruit = @client.recruits.order(:id).last
    assert_equal false, recruit.published?
    assert_redirected_to client_mypage_path
    follow_redirect!
    assert_match "この内容で審査依頼しました", response.body
    assert_match "審査中", response.body
  end

  test "clientsのログインURLは取引先ログインを出す" do
    get "/clients/sign_in"
    assert_response :success
    assert_match "取引先ログイン", response.body
    assert_no_match "管理者ログイン", response.body
  end

  private

  def inquiry_params
    {
      contact_via: "mail",
      contract: {
        company: "株式会社新規",
        name: "新規太郎",
        tel: "05000001111",
        email: "newco@example.com",
        address: "東京都",
        url: "https://example.com/jobs",
        message: "ホール募集",
        origin: "/foreign-jobs"
      }
    }
  end
end
