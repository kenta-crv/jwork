class PagesController < ApplicationController
  layout 'pages'

  before_action :initialize_contract

  def cargo; end
  def foreign_staffing; end
  def foreign_jobs; end
  def hotel; end
  def factory; end
  def restaurant; end
  def warehouse; end
  def language; end
  def english; end

  private

  def initialize_contract
    @contract = Contract.new
  end
end
