class PagesController < ApplicationController
  layout 'pages'

  before_action :set_breadcrumbs
  before_action :initialize_contract

  LP_LABELS = {
    'cargo'     => '軽貨物',
    'human'     => '人材紹介',
    'event'     => 'イベント',
    'cleaning'  => '清掃業',
    'logistics' => '物流業'
  }.freeze

  def cargo; end
  def human; end
  def event; end
  def cleaning; end
  def logistics; end

  private

  def initialize_contract
    @contract = Contract.new
  end

  def set_breadcrumbs
    add_breadcrumb 'トップ', root_path
    label = LP_LABELS[action_name]
    add_breadcrumb label, request.path if label
  end
end
