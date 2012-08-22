require 'maktoub/engine'
require 'yaml'

module Maktoub
  LAYOUT_PATH = "maktoub"
  TEMPLATE_PATH = "maktoub/newsletters"
  TEMPLATE_EXPAND_PATH = "app/views/#{TEMPLATE_PATH}"
  ARCHIVE_PATH = "app/views/maktoub/archives"
  
  class << self
    attr_accessor :manifest_file,
                    :from,
                    :test_to,
                    :subscription_preferences_url,
                    :unsubscribe_url

    attr_writer :email_field
    
  ### getters
    
    def manifest_file
      @manifest_file || "config/maktoub_newsletters.yml"
    end
    
    def email_field
      @email_field || :email
    end

    def subscribers
      @subscribers.call
    end

    def subscribers_extractor (&block)
      @subscribers = Proc.new &block
    end
    
  ### methods
    
    def manifest_yaml
      YAML.load(File.open(manifest_file))
    end
    
    # return newsletter hash (from manifest yaml)
    def find_newsletter(id)
      newsletters = manifest_yaml
      newsletter = newsletters[id] || raise("Unable to find newsletter with id=#{id} into the manifest (#{File.expand_path(manifest_file)})")
      newsletter.symbolize_keys!
      
      return newsletter
    end
    
    def find_newsletter_id_by_long_id(long_id)
      newsletters = manifest_yaml
      newsletters.each do |id, values|
        if values["long_id"].to_s == long_id.to_s
          return id
        end
      end
      
      return nil
    end
    
    # return template path and name for given newsletter
    def template_for(id)
      if file = Dir["#{Maktoub::TEMPLATE_EXPAND_PATH}/#{id}_*"].first
        template_file = File.basename(file) # TODO DRYify that code (duplicate with maktoub/lib/maktoub.rb)
        return "#{Maktoub::TEMPLATE_PATH}/#{template_file}"
      else
        raise Exception, "Unable to find newsletter template here: '#{Maktoub::TEMPLATE_EXPAND_PATH}/#{id}_*.hmtl.erb'"
      end
    end
    
    # return layout path and name for given newsletter
    def layout_for(id)
      newsletter = find_newsletter(id)
      if newsletter && newsletter[:layout]
        "#{Maktoub::LAYOUT_PATH}/#{newsletter[:layout]}"
      else
        "#{Maktoub::LAYOUT_PATH}/default"
      end
    end
  end
end

