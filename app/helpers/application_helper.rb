module ApplicationHelper
  def default_meta_tags
    {
      site: "特定技能外国人の求人紹介なら｜Future Jobs",
      title:"<%= yield(:title) | 合同会社ファクトル' %>",
      description: "特定技能・就労ビザ・永住ビザの外国人の求人紹介ならFuture Jobsにお任せください。豊富な案件で御社をサポートします。",
      canonical: request.original_url,  # 優先されるurl
      charset: "UTF-8",
      reverse: true,
      separator: '|',
      icon: [
        { href: image_url('favicon.ico') },
        { href: image_url('favicon.ico'),  rel: 'apple-touch-icon' },
      ],
	    canonical: request.original_url  # 優先されるurl

    }
  end

end
