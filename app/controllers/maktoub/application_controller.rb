module Maktoub
  class ApplicationController < ActionController::Base
  protected
    def render_404_error
      render :text => "404 Not Found", :status => 404, :layout => false
    end
    
    def inject_save_button
      html = <<-HTML
        <style type="text/css">
          #maktoub_buttons {
            position: absolute;
            width: 300px;
            left: 0; right: 0; margin-left: auto; margin-right: auto;
            padding-top: 10px;
            padding-bottom: 10px;
          }
          #maktoub_buttons a {
            display: block; text-align: center; color: black; text-decoration: none; padding: 5px; margin-top: 5px;
          }
          #maktoub_buttons a.view {
            border: 1px solid #0000cc; background-color: #9494ff
          }
          #maktoub_buttons a.save {
            border: 1px solid #cc0000; background-color: #ff9494
          }
        </style>
        <div id="maktoub_buttons">
          <a class="view" href="#{newsletter_url(@long_id)}">See archived version</a>
          <a class="save" href="#{save_newsletter_url(@id)}">Save this version to archive and see it</a>
        </div>
      HTML
      
      insert_text :before, /<\/body/, html
    end
    
    # Credits: rails3-footnotes
    #
    # Inserts text in to the body of the document
    # +pattern+ is a Regular expression which, when matched, will cause +new_text+
    # to be inserted before or after the match.  If no match is found, +new_text+ is appended
    # to the body instead. +position+ may be either :before or :after
    #
    def insert_text(position, pattern, new_text)
      index = case pattern
        when Regexp
          if match = response.body.match(pattern)
            match.offset(0)[position == :before ? 0 : 1]
          else
            response.body.size
          end
        else
          pattern
        end
      newbody = response.body
      newbody.insert index, new_text
      response.body = newbody
    end
  end
end
