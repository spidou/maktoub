module Maktoub
  class ComposeController < Maktoub::ApplicationController
    before_filter :find_newsletter, :except => :index
    before_filter :define_layout, :except => :index
    after_filter :inject_save_button, :only => :show
    
    def index
      @newsletters = Maktoub.manifest_yaml.sort.reverse
    end
    
    def show
      if @template
        render @template
      else
        render_404_error
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
