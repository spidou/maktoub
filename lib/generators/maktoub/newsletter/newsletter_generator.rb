module Maktoub
  module Generators
    class NewsletterGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      
      argument :subject, :type => :string, :required => false, :default => "Type your newsletter's subject here"
      class_option :layout, :type => :string, :desc => "Specify which layout you want for this newsletter"
      class_option :recipients, :type => :string, :desc => "Give an array of recipients, or a block to call to dynamically retrieve recipients"
      class_option :long_id_size, :type => :string, :default => 16, :desc => "Give the long_id size that you want (uncompatible with --long_id option)"
      class_option :long_id, :type => :string, :desc => "Give the long_id that you want"
      
      def update_manifest
        last_id = Maktoub.manifest_yaml.keys.map(&:to_i).uniq.max # get higher newsletter id from the manifest
        @new_id = last_id + 1
        
        content = <<-END
#{@new_id}:
  long_id: #{options.long_id || "#{@new_id}-#{generate_random_id(options.long_id_size.to_i)}"} # you can modify this as you want, but be sure it's unique
  subject: "#{subject}"
END
        
        if options.layout
          content += <<-END
  layout: "#{options.layout}"
END
        end

        content += <<-END
  recipients: "#{options.recipients}"

END
        prepend_file('config/maktoub_newsletters.yml', content)
      end
      
      def copy_layout
        copy_file "layout.html.erb", "app/views/layouts/maktoub/#{options.layout}.html.erb" if options.layout
      end
      
      def copy_template
        template "template.html.erb", template_destination
      end
      
    private
      def prepend_file(file, content)
        actual_content = File.read(file)
        new_content = content + actual_content
        File.open(file, 'wb') { |file| file.write(new_content) }
      end
      
      def generate_random_id(length)
        chars = ['0'..'9'].map{|r|r.to_a}.flatten
        Array.new(length).map{chars[rand(chars.size)]}.join
      end
      
      def template_destination
        "app/views/maktoub/newsletters/#{@new_id}_#{subject.underscore.gsub(" ", "_")}.html.erb"
      end
    end
  end
end
