# frozen_string_literal: true

require "erb"

# Column 記事へ注入する LINE CTA の HTML（CSS込み）
# 外部HTMLへ差し込むため、スタイルはインラインで完結させる
class ColumnLineCtaHtml
  def self.render(cta)
    kind = ERB::Util.html_escape(cta[:kind])
    badge = ERB::Util.html_escape(cta[:badge])
    title = ERB::Util.html_escape(cta[:title])
    lead = ERB::Util.html_escape(cta[:lead])
    label = ERB::Util.html_escape(cta[:cta_label])
    url = ERB::Util.html_escape(cta[:url])
    qr = ERB::Util.html_escape(cta[:qr_url])
    banner = ERB::Util.html_escape(cta[:banner_path])

    <<~HTML
      <style>
        .jwork-line-cta{--line-green:#06c755;--line-green-deep:#05a849;--line-ink:#0f172a;position:relative;margin:56px 0 28px;padding:28px 24px;border-radius:22px;overflow:hidden;isolation:isolate;background:linear-gradient(145deg,rgba(6,199,85,.12) 0%,rgba(255,255,255,.95) 42%,#fff 100%);border:1px solid rgba(6,199,85,.22);box-shadow:0 18px 40px rgba(6,199,85,.1),0 2px 8px rgba(15,23,42,.04);animation:jwork-line-cta-in .55s ease both}
        .jwork-line-cta__glow{position:absolute;inset:auto -20% -40% 40%;height:70%;background:radial-gradient(circle,rgba(6,199,85,.22) 0%,transparent 68%);pointer-events:none;z-index:0}
        .jwork-line-cta__inner{position:relative;z-index:1;display:grid;grid-template-columns:minmax(0,1fr) auto;gap:28px;align-items:center}
        .jwork-line-cta__badge{display:inline-flex;align-items:center;margin-bottom:10px;padding:4px 12px;border-radius:999px;background:rgba(6,199,85,.12);color:var(--line-green-deep);font-size:.75rem;font-weight:800;letter-spacing:.04em}
        .jwork-line-cta__title{margin:0 0 10px;font-size:clamp(1.25rem,2.4vw,1.65rem);font-weight:800;color:var(--line-ink);line-height:1.35;letter-spacing:-.02em}
        .jwork-line-cta__lead{margin:0 0 18px;color:#475569;font-size:.95rem;line-height:1.75}
        .jwork-line-cta__banner-link{display:block;max-width:420px;margin-bottom:14px;border-radius:14px;transition:transform .25s ease,filter .25s ease;filter:drop-shadow(0 10px 18px rgba(6,199,85,.22));text-decoration:none}
        .jwork-line-cta__banner-link:hover{transform:translateY(-2px) scale(1.015);filter:drop-shadow(0 14px 22px rgba(6,199,85,.3))}
        .jwork-line-cta__banner{display:block;width:100%;height:auto;border-radius:14px}
        .jwork-line-cta__btn{display:inline-flex;align-items:center;justify-content:center;gap:10px;min-height:48px;padding:.85rem 1.35rem;border-radius:999px;background:linear-gradient(135deg,#06c755 0%,#05a849 100%);color:#fff!important;font-weight:800;font-size:.98rem;text-decoration:none!important;box-shadow:0 10px 22px rgba(6,199,85,.28);transition:transform .2s ease,box-shadow .2s ease}
        .jwork-line-cta__btn:hover{transform:translateY(-1px);box-shadow:0 14px 28px rgba(6,199,85,.34);color:#fff!important}
        .jwork-line-cta__btn-icon{width:22px;height:22px;border-radius:7px;background:#fff;position:relative;flex:0 0 auto}
        .jwork-line-cta__btn-icon:before{content:"";position:absolute;inset:4px 4px 6px;border-radius:4px;background:var(--line-green)}
        .jwork-line-cta__btn-icon:after{content:"";position:absolute;left:5px;bottom:3px;width:0;height:0;border-style:solid;border-width:5px 6px 0 0;border-color:var(--line-green) transparent transparent transparent}
        .jwork-line-cta__qr{text-align:center;padding:14px;border-radius:18px;background:rgba(255,255,255,.82);border:1px solid rgba(6,199,85,.16);box-shadow:0 8px 20px rgba(15,23,42,.05)}
        .jwork-line-cta__qr-link{display:inline-block;border-radius:12px;transition:transform .2s ease}
        .jwork-line-cta__qr-link:hover{transform:scale(1.03)}
        .jwork-line-cta__qr-img{display:block;width:148px;height:148px;object-fit:contain;border-radius:10px;background:#fff}
        .jwork-line-cta__qr-caption{margin:10px 0 0;font-size:.78rem;font-weight:600;color:#64748b;line-height:1.55}
        .jwork-line-cta--recruit{background:linear-gradient(145deg,rgba(6,199,85,.16) 0%,rgba(255,255,255,.96) 48%,#fff 100%)}
        @keyframes jwork-line-cta-in{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
        @media (max-width:768px){.jwork-line-cta{margin:40px 0 20px;padding:22px 18px}.jwork-line-cta__inner{grid-template-columns:1fr;gap:18px}.jwork-line-cta__banner-link{max-width:none}.jwork-line-cta__btn{width:100%}.jwork-line-cta__qr{justify-self:center;width:100%;max-width:220px}.jwork-line-cta__qr-img{width:132px;height:132px;margin:0 auto}}
      </style>
      <section class="jwork-line-cta jwork-line-cta--#{kind}" data-jwork-cta="1">
        <div class="jwork-line-cta__glow" aria-hidden="true"></div>
        <div class="jwork-line-cta__inner">
          <div class="jwork-line-cta__copy">
            <span class="jwork-line-cta__badge">#{badge}</span>
            <h2 class="jwork-line-cta__title">#{title}</h2>
            <p class="jwork-line-cta__lead">#{lead}</p>
            <a class="jwork-line-cta__banner-link" href="#{url}" target="_blank" rel="noopener noreferrer">
              <img class="jwork-line-cta__banner" src="#{banner}" alt="LINEでカンタン #{label}" loading="lazy" width="1200" height="300">
            </a>
            <a class="jwork-line-cta__btn" href="#{url}" target="_blank" rel="noopener noreferrer">
              <span class="jwork-line-cta__btn-icon" aria-hidden="true"></span>
              <span>LINEで#{label}</span>
            </a>
          </div>
          <div class="jwork-line-cta__qr">
            <a class="jwork-line-cta__qr-link" href="#{url}" target="_blank" rel="noopener noreferrer">
              <img class="jwork-line-cta__qr-img" src="#{qr}" alt="#{label} LINE QRコード" loading="lazy" width="180" height="180">
            </a>
            <p class="jwork-line-cta__qr-caption">スマホでQRを読み取り<br>友だち追加できます</p>
          </div>
        </div>
      </section>
    HTML
  end
end
