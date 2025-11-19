Rails.application.routes.draw do
  devise_for :users

  get "dashboard", to: "web/dashboard#index", as: :dashboard

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

    resources :circles, only: [ :index, :show ] do
      resources :posts, only: [ :create ]
    end
    resources :contents, only: [ :index, :show ] do
      member do
        post :track_view
      end
    end
    resources :providers, only: [ :index, :show ] do
      member do
        post :track_contact
      end
    end
    resources :shares
  end

  get "home/index"

  authenticated :user do
    root to: "web/dashboard#index", as: :authenticated_root
  end

  root "home#index"
end
