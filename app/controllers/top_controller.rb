class TopController < ApplicationController

  def index
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

=begin
   def redirect
    line_url = "https://lin.ee/yVI3ClY"
    render inline: <<-HTML
      <!DOCTYPE html>
      <html lang="ja">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Redirecting...</title>

          <!-- Facebook Pixel Code -->
          <script>
          !function(f,b,e,v,n,t,s)
          {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
          n.callMethod.apply(n,arguments):n.queue.push(arguments)};
          if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
          n.queue=[];t=b.createElement(e);t.async=!0;
          t.src=v;s=b.getElementsByTagName(e)[0];
          s.parentNode.insertBefore(t,s)}(window, document,'script',
          'https://connect.facebook.net/en_US/fbevents.js');
          fbq('init', '609043125437314'); // Facebook Pixel ID
          fbq('track', 'PageView');
          </script>

          <noscript>
            <img height="1" width="1" 
            src="https://www.facebook.com/tr?id=609043125437314&ev=PageView&noscript=1"/>
          </noscript>
          <!-- End Facebook Pixel Code -->

          <script>
              setTimeout(function() {
                  window.location.href = "#{line_url}";
              }, 1000); // 1秒後にリダイレクト
          </script>
      </head>
      <body>
          <p>LINEへリダイレクト中...</p>
      </body>
      </html>
    HTML
  end
=end
end