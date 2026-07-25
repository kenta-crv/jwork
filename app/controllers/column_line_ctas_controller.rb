# frozen_string_literal: true

# Column 記事ページから呼ばれる導線 JSON
# 記事本体は nginx → drafity のまま。導線だけ jwork が返す。
class ColumnLineCtasController < ApplicationController
  protect_from_forgery except: :show

  def show
    cta = ColumnLineCta.resolve(
      code: params[:code],
      sub_genre: params[:sub_genre]
    )

    response.headers["Cache-Control"] = "public, max-age=300"
    render json: {
      kind: cta[:kind],
      html: ColumnLineCtaHtml.render(cta)
    }
  end
end
