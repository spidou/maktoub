require 'maktoub_task'

namespace :maktoub do
  desc "send :newsletter to the configured 'test_to' address"
  task :test, [:newsletter] => [:environment] do |t, args|
    MaktoubTask.new(args[:newsletter].to_i).test
  end
  
  
  desc "see full recipients list for :newsletter"
  task :list, [:newsletter] => [:environment] do |t, args|
    MaktoubTask.new(args[:newsletter].to_i).list
  end
  
  
  desc "send :newsletter to all subscribers"
  task :send, [:newsletter] => [:environment] do |t, args|
    MaktoubTask.new(args[:newsletter].to_i).send
  end
end

