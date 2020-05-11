class HomeController < ApplicationController
  def top
    if session[:user_id]
     session[:user_id] = nil
    end
    if session[:room_id]
      session[:room_id] = nil
    end
  end
end
