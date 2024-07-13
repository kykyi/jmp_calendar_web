

Rails.application.routes.draw do
  root 'calendars#new'
  resources :calendars, only: %i[create] do
    get :update_form, on: :collection
  end
end
