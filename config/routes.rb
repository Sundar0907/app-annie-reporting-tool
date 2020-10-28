Rails.application.routes.draw do

root 'reports#get_inputs'
resources :reports, only: [:index]
get '/getinput', to: 'reports#get_inputs'
post '/postinput', to: 'reports#post_inputs'
get '/postinput', to:  'reports#get_inputs'

end
