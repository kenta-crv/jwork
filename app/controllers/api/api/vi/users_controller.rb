class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  # スプレッドシートからのデータ登録用
  def sheet_create
    # ログで受信内容を確認
    Rails.logger.info "=== Received params from Sheet ==="
    Rails.logger.info params.inspect

    user_data = params[:user] || {}

    user = User.new(
      email:          user_data['email'],
      name:           user_data['full_name'],
      tel:            user_data['phone_number'],
      age:            user_data['date_of_birth'],
      nationality:    user_data['what_is_your_nationality?（あなたの国籍はどこですか？）'],
      past_business:  user_data['_what_job_are_you_currently_doing?（あなたはげんざいなんのしごとをしていますか？）'],
      password:       '11111111',
      password_confirmation: '11111111',
      past_genre:     user_data['what_industry_are[were]_you_in?（あなたはなんのしごとをしていますか？）'],
      past_year:      user_data['how_long_years_have_you_been_working_in_japan?（にほんでなんねんかんはたらきましたか？）'],
      qualifications: user_data['tell_us_all_the_qualifications_you_have（あなたがもっているすべてのしかくをかいてください）'],
      work_range:     user_data['please_tell_me_your_status_of_residence（visaのしゅるいをおしえてください）'],
      hope_work:      user_data['ad_name'],
      period:         user_data['_when_are_you_available_to_work?（あなたはいつからはたらけますか？）'],
      change_the_address: user_data['can_you_change_the_prefecture_you_live_in?あなたはすむとどふけんをかえることができますか?'],
      call_available: user_data['could_you_tell_me_the_time_you_will_come_out.（電話を出れる時間を教えてください。）'],
      speak_japanese: user_data['can_you_speak_japanese?（あなたはにほんごをはなすことができますか？）'],
      gender:         user_data['gender']
    )

    if user.save(validate: false)
      Rails.logger.info "=== User saved successfully ==="
      render json: { status: "ok" }, status: :created
    else
      Rails.logger.error "=== User save failed ==="
      Rails.logger.error user.errors.full_messages
      render json: { status: "error", errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end