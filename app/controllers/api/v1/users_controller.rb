# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token

      def sheet_create
        Rails.logger.info "=== Received params from Sheet ==="
        Rails.logger.info params.inspect

        user_data = params[:user] || {}

        # ユーザー作成
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

          # -------------------------------
          # メール送信（同期で確実に送る）
          # -------------------------------
          begin
            UserMailer.send_email(user).deliver_now!
            Rails.logger.info "=== Mail sent successfully to #{user.email} ==="
          rescue => e
            Rails.logger.error "=== Mail delivery failed for #{user.email}: #{e.message} ==="
          end

          # -------------------------------
          # SMS 送信（同期で即送信）
          # -------------------------------
          begin
            SendSmsJob.perform_now(user.id)
            Rails.logger.info "=== SMS sent successfully to #{user.id} ==="
          rescue => e
            Rails.logger.error "=== SMS delivery failed for #{user.id}: #{e.message} ==="
          end

          render json: { status: "ok", message: "User created, mail and SMS sent" }, status: :created
        else
          Rails.logger.error "=== User save failed ==="
          Rails.logger.error user.errors.full_messages
          render json: { status: "error", errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      # 取り込み時に必要なパラメータだけ許可
      def user_params
        params.require(:user).permit(
          :email, :full_name, :phone_number, :date_of_birth, :what_is_your_nationality,
          :_what_job_are_you_currently_doing, :what_industry_are_you_in, :how_long_years_have_you_been_working_in_japan,
          :tell_us_all_the_qualifications_you_have, :please_tell_me_your_status_of_residence, :ad_name,
          :_when_are_you_available_to_work, :can_you_change_the_prefecture_you_live_in,
          :could_you_tell_me_the_time_you_will_come_out, :can_you_speak_japanese, :gender
        )
      end
    end
  end
end
