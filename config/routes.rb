Rails.application.routes.draw do
  root 'calculate#index'

  get 'calculate/index'
  post 'calculate/calculate'
end
