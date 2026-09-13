module RecruitVisitor
  extend ActiveSupport::Concern

  VISITOR_COOKIE = :recruit_visitor_token
  VISITOR_COOKIE_EXPIRES = 1.year

  private

  def ensure_recruit_visitor_token
    token = cookies.signed[VISITOR_COOKIE].presence
    return token if token.present?

    token = SecureRandom.uuid
    cookies.signed[VISITOR_COOKIE] = {
      value: token,
      expires: VISITOR_COOKIE_EXPIRES.from_now,
      httponly: true,
      same_site: :lax
    }
    token
  end

  def recruit_visitor_token
    @recruit_visitor_token ||= ensure_recruit_visitor_token
  end
end
