Maktoub::Engine.routes.draw do

  if Rails.env.development?
    get ':id' => 'compose#show', :as => 'composing_newsletter'
    get ':id/save' => 'compose#save', :as => 'save_newsletter'
  end
  
  get 'archives/:long_id' => 'archives#show', :as => 'newsletter'

end

