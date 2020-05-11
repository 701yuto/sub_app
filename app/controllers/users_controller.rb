class UsersController < ApplicationController

def create
  @room = Room.new(
   number_of_players: params[:number_of_players],
   number_of_members: params[:number_of_members],
   order: 1)
  while 
    random = rand(1..100)
    unless Room.find_by(room_id: random)
    @room.room_id = random
    break  
    end
  end
  @room.save
  session[:room_id] = @room.room_id
  @user = User.new(room_id: @room.room_id)
  @user.save
  session[:user_id] = @user.id
  @room.user1 = @user.id
  @room.save
  redirect_to("/rooms/#{session[:room_id]}/matching")
end

def enter
    params[:room_id].tr!("０-９","0-9")
    if @room = Room.find_by(room_id: params[:room_id])
      @users = User.where(room_id: @room.room_id)

      if @room.number_of_players > @users.length
      @user = User.new(room_id: @room.room_id)
      @user.save

      if @room.user2.nil?
        @room.user2 = @user.id
      elsif @room.user3.nil?
        @room.user3 = @user.id
      elsif @room.user4.nil?
        @room.user4 = @user.id
      end

      @room.save
      session[:user_id] = @user.id
      session[:room_id] = @room.room_id
      redirect_to("/rooms/#{session[:room_id]}/matching")
      
      else
      flash[:notice] = "人数の上限を超えています"
      redirect_to("/")
      end  

    else
      flash[:notice] = "ルームがありません"
      redirect_to("/")
    end

end

def cancel
  @room = Room.find_by(room_id: session[:room_id])
    if session[:user_id] == @room.user2
      @room.user2 = nil
      @room.save
    elsif session[:user_id] == @room.user3
      @room.user3 = nil
      @room.save
    elsif session[:user_id] == @room.user4
      @room.user4 = nil
      @room.save
    end
    @current_user = User.find_by(id: session[:user_id])
    @current_user.destroy
    reset_session
    flash[:notice] = "ルームを退室しました"
    redirect_to("/")
end

def delete
  @room = Room.find_by(room_id: session[:room_id])
  @room.destroy
  @current_user = User.find_by(id: session[:user_id])
  @current_user.destroy
  reset_session
  flash[:notice] = "ルームを削除しました"
  redirect_to("/")
end

end