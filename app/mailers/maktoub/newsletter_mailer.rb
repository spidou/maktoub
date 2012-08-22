require 'premailer'

module Maktoub
  class NewsletterMailer < ActionMailer::Base
    default :from => Maktoub.from,
            :parts_order => [ "text/html", "text/plain" ]
    
    def publish(newsletter_id, params)
      find_newsletter(newsletter_id)
      
      @recipient = params[:recipient]
      @email = params[:email]
      mail_fields = {
        :subject => @subject,
        :to => params[:email]
      }

      premailer = Premailer.new(render(@template, :layout => @layout).to_s,
                        :with_html_string => true,
                        :link_query_string => CGI::escape("utm_source=newsletter&utm_medium=email&utm_campaign=#{@long_id}")
                      )

      mail(mail_fields) do |format|
        format.text { premailer.to_plain_text.html_safe }
        format.html { premailer.to_inline_css.html_safe }
      end
    end
    
  private
    # find newsletter from config yaml
    def find_newsletter(id)
      @id = id.to_i
      if newsletter = Maktoub.find_newsletter(@id)
        @subject = newsletter[:subject]
        @long_id = newsletter[:long_id]
        
        @template = Maktoub.template_for(@id)
        @layout = Maktoub.layout_for(@id)
      end
    end
    
  end
end

