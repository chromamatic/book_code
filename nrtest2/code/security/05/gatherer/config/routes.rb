#---
# Excerpted from "Rails 4 Test Prescriptions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/nrtest2 for more book information.
#---
Gatherer::Application.routes.draw do
  devise_for :users
  resources :tasks do
    member do
      patch :up
      patch :down
    end
  end

  resources :projects

  root to: "projects#index"
end
