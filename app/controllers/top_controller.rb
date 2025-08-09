class TopController < ApplicationController

  def index
  end

  def database 
  end 

  def lp
  end

  def zero 
  end

  def free
  end

  def line
  end

  def restaurant
  end

  def appointer
  end

  def documents
    if params[:from].present?
      AccessLog.create!(
        source: params[:from],
        path: request.path,
        ip: request.remote_ip,
        accessed_at: Time.current
      )
    end
    pdf_path = Rails.root.join('public', 'documents.pdf')
    if File.exist?(pdf_path)
      send_file pdf_path, filename: 'documents.pdf', type: 'application/pdf', disposition: 'attachment'
    else
      render plain: 'ファイルが見つかりません', status: 404
    end
  end  

  def databases
    if params[:from].present?
      AccessLog.create!(
        source: params[:from],
        path: request.path,
        ip: request.remote_ip,
        accessed_at: Time.current
      )
    end
    pdf_path = Rails.root.join('public', 'databases.pdf')
    if File.exist?(pdf_path)
      send_file pdf_path, filename: 'databases.pdf', type: 'application/pdf', disposition: 'attachment'
    else
      render plain: 'ファイルが見つかりません', status: 404
    end
  end  

  def redirect
    line_url = "https://page.line.me/522jmsbm"
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
end
