class TopController < ApplicationController
  before_action :set_breadcrumbs
  # app, ads, short 以外はカラムを表示
  before_action :set_columns, except: [:app, :ads, :short]
  before_action :initialize_contract

  # 各アクション（中身は空で各viewを自動呼び出し）
  def index; end
  def cargo; end
  def security; end
  def construction; end
  def cleaning; end
  def daily; end
  def housekeeping; end
  def event; end
  def logistics; end
  def app; end
  def ads; end
  def short; end

  private

  def initialize_contract
    @contract = Contract.new
  end

  def set_columns
    @columns = Column.order(created_at: :desc).limit(3)
  end

  def set_breadcrumbs
    # 修正：ドメインに応じたルートパスを取得
    add_breadcrumb 'トップ', current_root_path
    
    label = LpDefinition.label(action_name)
    add_breadcrumb label, request.path if label
  end


  def black 
  end
  def recruit 
  end
  def recruit_jp
  end
  def recruit_en 
  end
  def policy
  end
  def flow
    @current_step = 1
  end
  def entry
    @current_step = 2
  end
  def attention
    @current_step = 3
  end
  def apply
    @current_step = 4
  end
  def recruit_clean
  end

  def calculation
  end

  def database 
  end 

  def lp
  end

  def line
  end

  def information
  end

end
