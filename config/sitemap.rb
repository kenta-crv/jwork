require Rails.root.join("lib/public_sitemap")

host = "https://j-work.jp"
entries = PublicSitemap.compose(
  host: host,
  include_recruits: true,
  static_entries: [
    { path: "/", changefreq: "hourly", priority: 1.0 },
    { path: "/cargo", changefreq: "monthly", priority: 0.7 },
    { path: "/foreign-staffing", changefreq: "monthly", priority: 0.7 },
    { path: "/foreign-jobs", changefreq: "monthly", priority: 0.7 }
  ]
)

PublicSitemap.write!(host: host, entries: entries)
