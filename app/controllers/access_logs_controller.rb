class AccessLogsController < ApplicationController
  def index
    @logs = AccessLog.order(created_at: :desc)
  end
end
