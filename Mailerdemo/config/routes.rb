Rails.application.routes.draw do
  resources :users do
  get '/page/:page', action: :index, on: :collection
  get 'download_pdf', on: :member
  put :recover
  end
 
end
