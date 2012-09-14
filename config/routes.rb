Maktoub::Engine.routes.draw do

  if Rails.env.development?
    root :to => 'compose#index'
    get ':id' => 'compose#show', :as => 'composing_newsletter'
  end
  
  get 'archives/:long_id' => 'archives#show', :as => 'newsletter'

end

