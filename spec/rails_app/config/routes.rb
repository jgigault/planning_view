Rails.application.routes.draw do

  resources :projects, only: [:planning] do
    collection do
      get :planning
    end
  end

end
