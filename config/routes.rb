Rails.application.routes.draw do
  devise_for :users
  namespace :web do
    get "theme_preview/index"
    get "onboarding/step1", to: "onboarding#step1"
    get "onboarding/step2", to: "onboarding#step2"
    get "onboarding/step3", to: "onboarding#step3"
    get "onboarding/step4", to: "onboarding#step4"
    get "onboarding/step5", to: "onboarding#step5"
    post "onboarding/submit", to: "onboarding#submit"
    get "theme_preview", to: "theme_preview#index"
    get "/profile", to: "profiles#show", as: :profile
    get "chatbot", to: "chatbot#index", as: :chatbot

    # ✅ This defines web_circles_path and web_contents_path
    resources :circles, only: [ :index, :show ]
    resources :contents, only: [ :new, :create, :index, :show ]
    resources :shares
  end

  get "home/index"
  root "home#index"
end
