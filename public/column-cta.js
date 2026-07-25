(function () {
  "use strict";

  function articleCodeFromPath() {
    var match = location.pathname.match(/^\/columns\/([^\/]+)\/?$/);
    return match ? decodeURIComponent(match[1]) : null;
  }

  function insertHtml(html) {
    if (!html || document.querySelector("[data-jwork-cta='1']")) return;

    var wrapper = document.createElement("div");
    wrapper.innerHTML = html;

    // <style> と <section> の両方が来るため、先頭要素だけだと見た目が出ない
    var nodes = [];
    while (wrapper.firstChild) {
      nodes.push(wrapper.firstChild);
      wrapper.removeChild(wrapper.firstChild);
    }
    if (!nodes.length) return;

    var footer = document.querySelector(".column-footer");
    if (footer && footer.parentNode) {
      for (var i = 0; i < nodes.length; i++) {
        footer.parentNode.insertBefore(nodes[i], footer);
      }
      return;
    }

    var body = document.querySelector(".blog-container .container") || document.querySelector(".blog-container") || document.body;
    for (var j = 0; j < nodes.length; j++) {
      body.appendChild(nodes[j]);
    }
  }

  function run() {
    var code = articleCodeFromPath();
    if (!code) return;

    var url = "/column_line_cta.json?code=" + encodeURIComponent(code);
    fetch(url, { credentials: "same-origin" })
      .then(function (res) {
        if (!res.ok) throw new Error("cta status " + res.status);
        return res.json();
      })
      .then(function (data) {
        insertHtml(data && data.html);
      })
      .catch(function () {
        // 導線失敗でも記事本体は壊さない
      });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", run);
  } else {
    run();
  }
})();
