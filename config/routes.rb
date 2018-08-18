Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :destroy] do
      member do
        patch :set_best
      end
    end
  end

  resources :attachments, only: :destroy
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
