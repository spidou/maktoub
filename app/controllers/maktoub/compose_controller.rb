module Maktoub
  class ComposeController < Maktoub::ApplicationController
    before_filter :find_newsletter
    before_filter :define_layout
    after_filter :inject_save_button, :only => :show
    
    def show
      if @template
        render @template
      else
        render_404_error
      end
    end
    
    def save
      @archive = true # hide the link to archive_url
      if @template && data = render_to_string(@template)
        file_path = "#{Maktoub::ARCHIVE_PATH}/#{@id}.html"
        
        # save to static file
        File.open(file_path, "w") { |f| f << data }
        
        redirect_to newsletter_path(@long_id)
      end
    end
    
  private
    # find newsletter from config yaml
    def find_newsletter
      @id = params[:id].to_i
      if @newsletter = Maktoub.find_newsletter(@id)
        @long_id = @newsletter[:long_id]
        @subject = @newsletter[:subject]
        
        @template = Maktoub.template_for(@id)
      end
    end
    
    # define layout to use from config yaml
    def define_layout
      self.class.layout Maktoub.layout_for(@id)
    end
    
  end
end
