class DraftsController < ApplicationController
before_action :set_room_user
before_action :memo, {only:[:decide]}

def set_room_user
  @room = Room.find_by(room_id: session[:room_id])
  @current_user = User.find_by(id: session[:user_id])
  @user1 = User.find_by(id: @room.user1)
  @user2 = User.find_by(id: @room.user2)
  @user3 = User.find_by(id: @room.user3)
  @user4 = User.find_by(id: @room.user4)
end

def memo
  if params[:memo]
  @current_user.memo = params[:memo]
  @current_user.save
  end
end

def preparation
end

def lottery
end

def preparation_second
end

def lottery_second
end

def second_select
end

def second_decide
  if params[:select]
    @current_user.select = params[:select]
    @current_user.save
    @room.next = @room.next + 1
    @room.save
    redirect_to("/drafts/:room_id/second_wait")
  elsif params[:select].nil? 
    @members = Member.all
    flash[:notice] = "メンバーを選択してください"
    redirect_to("/drafts/:room_id/second_select")
  end
end

def second_to_wait
  @room.next = @room.next + 1
  @room.save
  redirect_to("/drafts/:room_id/second_wait")
end

def second_wait

  if @room.next == 0
    redirect_to("/drafts/:room_id/second_announcement")
  end
  
  if @room.next == @room.number_of_players && @current_user.id == @room.user1
    if (@room.number_of_players == 2 && @user1.select && @user2.select) \
    || (@room.number_of_players == 3 && @user1.select && @user2.select && @user3.select) \
    || (@room.number_of_players == 4 && @user1.select && @user2.select && @user3.select && @user4.select)
    
        @room.next = 0
        @room.save
        redirect_to("/drafts/:room_id/second_check")
    end
  end

end

def second_check

  @winning_users = User.where(room_id: session[:room_id]).where(lottery:0).or(User.where(room_id: session[:room_id]).where(lottery:2)).or(User.where(room_id: session[:room_id]).where(lottery:4))
  @winning_users.each do |winning_user|
    winning_user.lottery = nil
    winning_user.save 
  end

  @users = User.where(room_id: session[:room_id]).where(lottery:1).or(User.where(room_id: session[:room_id]).where(lottery:3))
  @users.each do |user|
    user.lottery = 0
    user.save
  end

  if @room.number_of_players == 2
    redirect_to("/drafts/:room_id/second_announcement_two")
  elsif @room.number_of_players == 3
    redirect_to("/drafts/:room_id/second_announcement_three")
  elsif @room.number_of_players == 4
    redirect_to("/drafts/:room_id/second_announcement_four")
  end

end

def second_announcement_two
if @user1.select == @user2.select  
  @user1.lottery = 1
  @user2.lottery = 1
else
  # 被りなし
  @draft1 = Draft.new(
    user_id:@user1.id,
      room_id:session[:room_id],
      member_name: @user1.select,
      order: @room.order) 
  @draft1.save
  @draft2 = Draft.new(
    user_id: @user2.id,
    room_id:session[:room_id],
    member_name: @user2.select,
    order: @room.order) 
  @draft2.save

  @drafts = Draft.where(user_id:session[:user_id])
  @room.order =  @drafts.length + 1
  @room.save 
  
  # 被りなし
end
@user1.save
@user2.save

if User.find_by(room_id:session[:room_id],lottery:1)
  @selecting_users = User.where(room_id: session[:room_id]).where(lottery:1)
  @winning_user = @selecting_users.sample
  @winning_user.lottery = 2
  @winning_user.save
  @losing_users = User.where(room_id: session[:room_id]).where(lottery:1)
  @losing_users.each do |losing_user|
    losing_user.select = nil
    losing_user.save
  end
end

redirect_to("/drafts/:room_id/second_announcement")
end

def second_announcement_three
if @user1.select == @user2.select  
  if @user1.select == @user3.select  
    @user1.lottery = 1
    @user2.lottery = 1
    @user3.lottery = 1
  else
    @user1.lottery = 1
    @user2.lottery = 1
  end
elsif @user1.select == @user3.select 
  @user1.lottery = 1
  @user3.lottery = 1
elsif @user2.select == @user3.select 
  @user2.lottery = 1
  @user3.lottery = 1
else
  # 被りなし
  @draft1 = Draft.new(
    user_id:@user1.id,
      room_id:session[:room_id],
      member_name: @user1.select,
      order: @room.order) 
  @draft1.save
  @draft2 = Draft.new(
    user_id: @user2.id,
    room_id:session[:room_id],
    member_name: @user2.select,
    order: @room.order) 
  @draft2.save
  @draft3 = Draft.new(
    user_id: @user3.id,
    room_id:session[:room_id],
    member_name: @user3.select,
    order: @room.order) 
  @draft3.save
  
  @drafts = Draft.where(user_id:session[:user_id])
  @room.order =  @drafts.length + 1
  @room.save 

  # 被りなし
end
@user1.save
@user2.save
@user3.save

if User.find_by(room_id:session[:room_id],lottery:1)
  @selecting_users = User.where(room_id: session[:room_id]).where(lottery:1)
  @winning_user = @selecting_users.sample
  @winning_user.lottery = 2
  @winning_user.save
  @losing_users = User.where(room_id: session[:room_id]).where(lottery:1)
  @losing_users.each do |losing_user|
    losing_user.select = nil
    losing_user.save
  end
end

redirect_to("/drafts/:room_id/second_announcement")
end

def second_announcement_four
  if @user1.select == @user2.select  
    if @user1.select == @user3.select  
      if @user1.select == @user4.select  
        # user1.select == user2.select == user3.select == user4.select
        @user1.lottery = 1
        @user2.lottery = 1
        @user3.lottery = 1
        @user4.lottery = 1

      else
        # user1.select == user2.select == user3.select
        @user1.lottery = 1
        @user2.lottery = 1
        @user3.lottery = 1
        
      end
    elsif @user1.select == @user4.select  
      # user1.select == user2.select == user4.select  
      @user1.lottery = 1
      @user2.lottery = 1
      @user4.lottery = 1
      
    elsif @user3.select == @user4.select
      # user1.select == user2.select  &&  user3.select == user4.select
      @user1.lottery = 1
      @user2.lottery = 1
      @user3.lottery = 3
      @user4.lottery = 3
        
    else
      # user1.select == user2.select 
      @user1.lottery = 1
      @user2.lottery = 1
      
    end

  elsif @user2.select == @user3.select
    if @user3.select == @user4.select
      # user2.select == user3.select == user4.select
      @user2.lottery = 1
      @user3.lottery = 1
      @user4.lottery = 1
      
    elsif @user1.select == @user4.select
      # user2.select == user3.select  && user1.select == user4.select
      @user1.lottery = 1
      @user2.lottery = 3
      @user3.lottery = 3
      @user4.lottery = 1
      
    else
      # user2.select == user3.select 
      @user2.lottery = 1
      @user3.lottery = 1
      
    end
  elsif @user1.select == @user3.select
    if @user1.select == @user4.select
      @user1.lottery = 1
      @user3.lottery = 1
      @user4.lottery = 1
      
    elsif @user2.select == @user4.select
      @user1.lottery = 1
      @user2.lottery = 3
      @user3.lottery = 1
      @user4.lottery = 3
      
    else
      # user1.select == user3.select
      @user1.lottery = 1
      @user3.lottery = 1
      
    end
  elsif @user1.select == @user4.select
    # user1.select == user4.select
    @user1.lottery = 1
    @user4.lottery = 1

  elsif @user2.select == @user4.select
      # user2.select == user4.select
      @user2.lottery = 1
      @user4.lottery = 1
      
  elsif @user3.select == @user4.select
      # user3.select == user4.select
      @user3.lottery = 1
      @user4.lottery = 1
      
  else
    # 被りなし
    @draft1 = Draft.new(
      user_id:@user1.id,
        room_id:session[:room_id],
        member_name: @user1.select,
        order: @room.order) 
    @draft1.save
    @draft2 = Draft.new(
      user_id: @user2.id,
      room_id:session[:room_id],
      member_name: @user2.select,
      order: @room.order) 
    @draft2.save
    @draft3 = Draft.new(
      user_id: @user3.id,
      room_id:session[:room_id],
      member_name: @user3.select,
      order: @room.order) 
    @draft3.save
    @draft4 = Draft.new(
      user_id: @user4.id,
      room_id:session[:room_id],
      member_name: @user4.select,
      order: @room.order) 
    @draft4.save

    @drafts = Draft.where(user_id:session[:user_id])
    @room.order =  @drafts.length + 1
    @room.save 

    # 被りなし
  end

  @user1.save
  @user2.save
  @user3.save
  @user4.save

  if User.find_by(room_id:session[:room_id],lottery:1)
    @selecting_users = User.where(room_id: session[:room_id]).where(lottery:1)
    @winning_user = @selecting_users.sample
    @winning_user.lottery = 2
    @winning_user.save
    @losing_users = User.where(room_id: session[:room_id]).where(lottery:1)
    @losing_users.each do |losing_user|
      losing_user.select = nil
      losing_user.save
    end

    if User.find_by(room_id:session[:room_id],lottery:3)
      @selecting_users2 = User.where(room_id: session[:room_id]).where(lottery:3)
      @winning_user2 = @selecting_users2.sample
      @winning_user2.lottery = 4
      @winning_user2.save
      @losing_users2 = User.where(room_id: session[:room_id]).where(lottery:3)
      @losing_users2.each do |losing_user2|
        losing_user2.select = nil
        losing_user2.save
      end
      
    end

  end

  redirect_to("/drafts/:room_id/second_announcement")
end

def second_announcement
end

def second_branch
  if User.find_by(room_id:session[:room_id],lottery:1)
    redirect_to("/drafts/:room_id/second_preparation")
  else
    redirect_to("/rooms/:room_id/result")
  end
end

def second_preparation
end

end
