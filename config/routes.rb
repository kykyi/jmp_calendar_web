Rails.application.routes.draw do
  root "calendars#new"
  resources :calendars, only: %i[create]
end
