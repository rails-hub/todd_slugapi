SlugAPI::Application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'


  match 'api/register' => 'user#register_api', via: [:post]
  match 'api/login' => 'user#login_api', via: [:post]
  match 'api/invite' => 'friendship#invite_friend_api', via: [:post]
  match 'api/accept_invite' => 'friendship#accept_invite_api', via: [:post]
  match 'api/get_friends' => 'friendship#get_friends_api', via: [:post]
  match 'api/accept_friend' => 'friendship#accept_friend_api', via: [:post]
  match 'api/reject_friend' => 'friendship#reject_friend_api', via: [:post]
  match 'api/get_pending' => 'friendship#get_pending_api', via: [:post]
  match 'api/get_shots' => 'shot#get_shots_api', via: [:post]
  match 'api/post_shot' => 'shot#post_shot_api', via: [:post]
  match 'api/delete_shot' => 'shot#delete_shot_api', via: [:post]
  match 'api/get_challenges' => 'challenge#get_challenges', via: [:post]
  match 'api/quit_challenge' => 'challenge#quit_challenge_api', via: [:post]
  match 'api/challenge_player' => 'challenge#challenge_player', via: [:post]
  match 'api/accept_challenge' => 'challenge#accept_challenge', via: [:post]
  match 'api/update_profile' => 'user#update_profile', via: [:post]
  match 'api/update_password' => 'user#update_password', via: [:post]
  match 'api/user_device_token' => 'user#update_device_token', via: [:post]

  match 'tests/api_test' => 'api#token_test', via: [:post]


  root :to => 'user#admin_log_in'


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
