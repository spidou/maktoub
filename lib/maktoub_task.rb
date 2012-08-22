ArrayRecipient = Struct.new(:email)

class MaktoubTask
  attr_accessor :newsletter_id, :newsletter, :recipients
  
  def initialize(id)
    @newsletter_id = id
    @newsletter = Maktoub.find_newsletter(id)
    
    # find recipients
    case @newsletter[:recipients]
    when String
      begin
        @recipients = eval(@newsletter[:recipients]).call
      rescue Exception => e
        raise e, "'recipients' expects to receive a block (#{File.expand_path(Maktoub.manifest_file)})\noriginal message: #{e.message}\noriginal backtrace: #{e.backtrace.inspect}"
      end
    when Array
      @recipients = @newsletter[:recipients].map{ |email| ArrayRecipient.new(email) }
    else
      raise "Don't know what to do with your recipients: #{@newsletter[:recipients].class}:#{@newsletter[:recipients].inspect}"
    end
  end
  
  def test
    announce
    
    if Maktoub::NewsletterMailer.method_defined? :delay
      Maktoub::NewsletterMailer.delay(:priority => 5, :queue => 'maktoub').publish(@newsletter_id, :email => Maktoub.test_to, :recipient => nil)
      puts "test delayed to #{Maktoub.test_to}"
    else
      Maktoub::NewsletterMailer.publish(@newsletter_id, :email => Maktoub.test_to, :recipient => nil).deliver
      puts "test delivered to #{Maktoub.test_to}"
    end
    puts "This newsletter is configured to be sent to #{@recipients.size} recipients. Run 'rake maktoub:list[#{@newsletter_id}]' to see the full recipients list"
  end
  
  def list
    announce
    
    puts "configured to be sent to #{recipients.size} recipients :"
    recipients.each{ |r| puts " - " + r.send(Maktoub.email_field) }
  end
  
  def send
    announce
    
    @recipients.each do |recipient|
      recipient_email = recipient.send(Maktoub.email_field)
      if Maktoub::NewsletterMailer.method_defined? :delay
        Maktoub::NewsletterMailer.delay(:priority => 5, :queue => 'maktoub').publish(@newsletter_id, :email => recipient_email, :recipient => recipient)
        puts "- delayed to #{recipient_email}"
      else
        Maktoub::NewsletterMailer.publish(@newsletter_id, :email => recipient_email, :recipient => recipient).deliver
        puts "- delivered to #{recipient_email}"
      end
      #TODO écrire un fichier log pour enregistrer les adresses à qui ont été envoyé la newsletter (+date +id objet +identifiant newsletter)
    end
  end
  
private
  def announce
    puts "==== Newsletter '#{@newsletter_id}' : \"#{@newsletter[:subject]}\" (using layout '#{@newsletter[:layout] || 'default'}')"
  end
end
