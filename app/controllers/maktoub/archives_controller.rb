module Maktoub
  class ArchivesController < Maktoub::ApplicationController
    caches_page :only => [:show]
    
    def show
      @archive = true # hide the link to archive_url
      
      if params[:long_id]
        if id = Maktoub.find_newsletter_id_by_long_id(params[:long_id])
          
          if newsletter = Maktoub.find_newsletter(id)
            @subject = newsletter[:subject]
            
            if template = Maktoub.template_for(id)
              render template, :layout => Maktoub.layout_for(id)
            else
              render_404_error
            end
          end
          
        else
          render_404_error
        end
      else
        render_404_error
      end
    end

  end
end

