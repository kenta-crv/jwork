# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token

      def sheet_create
        Rails.logger.info "=== Received params from Sheet ==="
        Rails.logger.info params.inspect

        user_data = params[:user] || {}

        # ================================
        # 修正ポイント：重複防止
        # ================================
        user = User.find_or_initialize_by(email: user_data['email'])

        user.assign_attributes(
          name:           user_data['full_name'],
          tel:            user_data['phone_number'],
          age:            user_data['date_of_birth'],
          address:        user_data['city'],
          nationality:    user_data['what_is_your_nationality?（あなたの国籍はどこですか？）'],
          drivers_lisence: user_data["do_you_have_a_driver's_lisence?（うんてんめんきょしょうはもっていますか？）"],
          password:       '11111111',
          password_confirmation: '11111111',
          work_range:     user_data['please_tell_me_your_status_of_residence（visaのしゅるいをおしえてください）'],
          past_year:      user_data['how_long_years_have_you_been_working_in_japan?（にほんでなんねんかんはたらきましたか？）'],
          period:         user_data['when_are_you_available_to_work?（あなたはいつからはたらけますか？）'],
          hope_work:      user_data['ad_name'],
          speak_japanese: user_data['can_you_speak_japanese?（あなたはにほんごをはなすことができますか？）'],
          gender:         user_data['gender']
        )

        if user.save(validate: false)
          Rails.logger.info "=== User saved successfully ==="

          # -------------------------------
          # メール送信
          # -------------------------------
          begin
            UserMailer.send_email(user).deliver_now
            Rails.logger.info "=== Mail sent successfully to #{user.email} ==="
          rescue => e
            Rails.logger.error "=== Mail delivery failed for #{user.email}: #{e.message} ==="
          end

          # -------------------------------
          # SMS送信
          # -------------------------------
          begin
            SendSmsJob.perform_now(user.id)
            Rails.logger.info "=== SMS sent successfully to #{user.id} ==="
          rescue => e
            Rails.logger.error "=== SMS delivery failed for #{user.id}: #{e.message} ==="
          end

          render json: { status: "ok", message: "User created/updated, mail and SMS sent" }, status: :created
        else
          Rails.logger.error "=== User save failed ==="
          Rails.logger.error user.errors.full_messages
          render json: { status: "error", errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

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