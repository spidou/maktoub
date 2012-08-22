module Maktoub
  class ArchivesController < Maktoub::ApplicationController
    caches_page :only => [:show]
    
    def show
      if params[:long_id]
        if id = Maktoub.find_newsletter_id_by_long_id(params[:long_id])
          file_path = "#{Maktoub::ARCHIVE_PATH}/#{id}.html"
          if File.exists?(file_path)
            render file_path, :layout => false
          else
            render_404_error
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

