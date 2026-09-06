// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= stub pages
//= require_tree .

$(function() {
    $('.navToggle').click(function() {
        $(this).toggleClass('active');

        if ($(this).hasClass('active')) {
            $('.globalMenuSp').addClass('active');
        } else {
            $('.globalMenuSp').removeClass('active');
        }
    });
});


// 確実にDOMがある状態で実行
document.addEventListener("turbolinks:load", function() {
  var unitPriceInput = document.getElementById("unit_price");
  var quantityInput = document.getElementById("quantity");
  var daysInput = document.getElementById("days");

  var totalRewardEl = document.getElementById("total_reward");
  var totalExpenseEl = document.getElementById("total_expense");
  var netIncomeEl = document.getElementById("net_income");

  // すべての要素が存在する場合のみ実行（Nullガード）
  if (unitPriceInput && quantityInput && daysInput && totalRewardEl && totalExpenseEl && netIncomeEl) {
    function calculate() {
      var unitPrice = parseFloat(unitPriceInput.value) || 0;
      var quantity = parseFloat(quantityInput.value) || 0;
      var days = parseFloat(daysInput.value) || 0;

      var totalReward = unitPrice * quantity * days;
      var totalExpense = 25000 + 25000 + 1500;
      var netIncome = totalReward - totalExpense;

      totalRewardEl.textContent = totalReward.toLocaleString();
      totalExpenseEl.textContent = totalExpense.toLocaleString();
      netIncomeEl.textContent = netIncome.toLocaleString();
    }

    [unitPriceInput, quantityInput, daysInput].forEach(function(input) {
      input.addEventListener("input", calculate);
    });

    // 初期計算
    calculate();
  }
});


// コピーボタン処理（Turbolinks環境に対応）
document.addEventListener('turbolinks:load', () => {
  const copyButtons = document.querySelectorAll('.copy-btn');

  copyButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      const text = btn.dataset.clipboardText;
      navigator.clipboard.writeText(text).then(() => {
        alert('メール文をコピーしました。');
      }).catch(() => {
        alert('コピーに失敗しました。');
      });
    });
  });
});


// ドキュメント全体に変更イベントのリスナーを設定
$(document).on('change', '.update-status', function() {
  const selectElement = $(this);
  const userId = selectElement.data('user-id');
  const newStatus = selectElement.val();
  
  // CSRFトークンを取得
  const authenticityToken = $('meta[name="csrf-token"]').attr('content');

  // Ajaxリクエストの実行
  $.ajax({
    url: `/users/${userId}`, // /users/:id にリクエストを送信
    method: 'PATCH',        
    dataType: 'json',       
    data: { 
      user: {
        status: newStatus
      },
      authenticity_token: authenticityToken 
    },
    success: function(response) {
      // 成功時の処理
      console.log('ステータスが正常に更新されました:', response);
    },
    error: function(xhr) {
      // エラー時の処理 (バリデーションエラーなど)
      console.error('ステータスの更新に失敗しました:', xhr.responseText);
      alert('ステータスの更新に失敗しました。詳細: ' + (xhr.responseJSON && xhr.responseJSON.errors ? xhr.responseJSON.errors.join(', ') : 'サーバーエラー'));
    }
  });
});


// チェックボックスによるボタン活性・非活性制御（エラー修正箇所）
document.addEventListener('turbolinks:load', () => {
  const checks = document.querySelectorAll('.confirm-check');
  const nextButton = document.getElementById('next-button');

  // ページ内に「next-button」が存在する場合のみ処理を実行する（Nullガード）
  if (nextButton) {
    const toggleButton = () => {
      const allChecked = Array.from(checks).every(c => c.checked);
      if (allChecked) {
        nextButton.classList.remove('disabled');
        nextButton.style.pointerEvents = 'auto';
      } else {
        nextButton.classList.add('disabled');
        nextButton.style.pointerEvents = 'none';
      }
    };

    checks.forEach(check => {
      check.addEventListener('change', toggleButton);
    });

    // 初期状態の判定を実行
    toggleButton();
  }
});

document.addEventListener("turbolinks:load", function() {
  document.querySelectorAll(".auth-form__drop").forEach(function(drop) {
    var input = drop.querySelector(".auth-form__file");
    var name = drop.querySelector(".auth-form__drop-name");
    if (!input || !name) return;
    var empty = name.getAttribute("data-empty") || "No file selected";
    input.addEventListener("change", function() {
      if (input.files && input.files[0]) {
        name.textContent = input.files[0].name;
        drop.classList.add("is-filled");
      } else {
        name.textContent = empty;
        drop.classList.remove("is-filled");
      }
    });
  });
});