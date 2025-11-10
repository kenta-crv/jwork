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
});


// app/javascript/packs/application.js または index用JS
document.addEventListener('DOMContentLoaded', () => {
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
