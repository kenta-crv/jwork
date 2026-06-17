module ApplicationHelper
  def default_meta_tags
    {
      site: "外国人専門の人材提供ならJ Work｜株式会社セールスプロ",
      title: "合同会社ファクトル", # ← ここを単純な文字列にする
      reverse: true,
      separator: '|',
      description: "",
      canonical: request.original_url,
      charset: "UTF-8",
      icon: [
        { href: image_url('favicon.ico') },
        { href: image_url('favicon.ico'),  rel: 'apple-touch-icon' },
      ]

    }
  end
def step_class(step_number)
  return 'is-active' if step_number == @current_step
  return 'is-done'   if step_number < @current_step
  ''
end
end
