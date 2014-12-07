Maftuh::Application.routes.draw do
  resources :districts

  root 'checkpoints#index'
  resources :checkpoints

  post 'twilio/voice' => 'twilio#voice'
  get 'twilio/sms' => 'twilio#sms'
end
