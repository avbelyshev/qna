Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      patch 'set_like'
      patch 'set_dislike'
      patch 'cancel_vote'
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, concerns: [:votable], only: [:create, :update, :destroy] do
      member do
        patch :set_best
      end
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
