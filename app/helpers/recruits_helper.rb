module RecruitsHelper
  def recruit_metric_row(recruit, options = {})
    show_labels = options.fetch(:labels, false)
    content_tag(:div, class: "recruit-metrics") do
      safe_join([
        recruit_metric_item("view", recruit.views_count.to_i, "Views", show_labels),
        recruit_metric_item("save", recruit.saves_count.to_i, "Saved", show_labels),
        recruit_metric_item("apply", recruit.applications_count.to_i, "Applies", show_labels)
      ])
    end
  end

  def recruit_metric_item(kind, count, label, show_labels)
    content_tag(:span, class: "recruit-metric recruit-metric--#{kind}", title: label) do
      safe_join([
        recruit_metric_icon(kind),
        content_tag(:span, count, class: "recruit-metric__count", data: { metric: kind }),
        (show_labels ? content_tag(:span, label, class: "recruit-metric__label") : nil)
      ].compact)
    end
  end

  def recruit_metric_icon(kind)
    case kind.to_s
    when "view"
      <<~SVG.html_safe
        <svg class="recruit-metric__icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path fill="currentColor" d="M12 5c-5 0-9.27 3.11-11 7 1.73 3.89 6 7 11 7s9.27-3.11 11-7c-1.73-3.89-6-7-11-7zm0 12a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-8a3 3 0 1 0 .001 6.001A3 3 0 0 0 12 9z"/></svg>
      SVG
    when "save"
      <<~SVG.html_safe
        <svg class="recruit-metric__icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path fill="currentColor" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 6 4 4 6.5 4c1.74 0 3.41 1 4.22 2.44C11.09 5 12.76 4 14.5 4 17 4 19 6 19 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
      SVG
    else
      <<~SVG.html_safe
        <svg class="recruit-metric__icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path fill="currentColor" d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
      SVG
    end
  end
end
