Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'kaziri_skill1#index'

  post '/' => 'kaziri_skill1#index'

end
