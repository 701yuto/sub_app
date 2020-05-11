class RoomsController < ApplicationController
before_action :set_room_user
before_action :memo, {only:[:meeting,:select,:decide,:next]}
  

def set_room_user
  @room = Room.find_by(room_id: session[:room_id])
  @current_user = User.find_by(id: session[:user_id])
  @user1 = User.find_by(id: @room.user1)
  @user2 = User.find_by(id: @room.user2)
  @user3 = User.find_by(id: @room.user3)
  @user4 = User.find_by(id: @room.user4)
end

def matching

  unless Room.find_by(room_id: session[:room_id])
    @current_user = User.find_by(id: session[:user_id])
    @current_user.destroy
    reset_session
    flash[:notice] = "ルームが削除されました"
    redirect_to("/")
  end

  @users = User.where(room_id: session[:room_id])

  if @users.length == @room.number_of_players && @current_user.id == @room.user1
    redirect_to("/rooms/:room_id/create")
  end
  
  if  @room.next
    redirect_to("/rooms/:room_id/group")
  end
  
end

def create
  @room.next = 0
  @room.save
  redirect_to("/rooms/:room_id/group")
end

def group
end

def group_confirm  
  if User.find_by(name:"#{params[:name]}坂46",room_id:session[:room_id])
    flash[:notice] = "他のプレーヤーと同じグループ名です"
    @current_user.color = params[:color] 
    @current_user.save
    redirect_to("/rooms/:room_id/group")
  else
  @current_user.name = params[:name] + "坂46"
  @current_user.logo =  "/logo/" + params[:color].delete("#") + ".png"
    if params[:color] == "#ffffff"
    @current_user.color = "#333333" 
    else
    @current_user.color = params[:color] 
    end
  @current_user.save
  redirect_to("/rooms/:room_id/meeting")
  end

end

def memo
  if params[:memo]
  @current_user.memo = params[:memo]
  @current_user.save
  end
end

def meeting
end

def select

end

def decide
  if params[:select]
    if @room.next
      @room.next = nil 
      @room.save
      if @user1 && @user1.select
        @user1.select = nil
        @user1.save
      end
      if @user2 && @user2.select
        @user2.select = nil
        @user2.save
      end
      if @user3 && @user3.select
        @user3.select = nil
        @user3.save
      end
      if @user4 && @user4.select
        @user4.select = nil
        @user4.save
      end
    end

    if @current_user.lottery
      @current_user.lottery = nil
      @current_user.save
    end

    @current_user.select = params[:select]
    @current_user.save
    redirect_to("/rooms/:room_id/wait")
  elsif params[:select].nil? 
    @members = Member.all
    flash[:notice] = "メンバーを選択してください"
    redirect_to("/rooms/:room_id/select")
  end
end

def wait

  if @room.next 
    redirect_to("/rooms/:room_id/announcement")

  elsif (@room.number_of_players == 2 && @user1.select && @user2.select) \
    || (@room.number_of_players == 3 && @user1.select && @user2.select && @user3.select) \
    || (@room.number_of_players == 4 && @user1.select && @user2.select && @user3.select && @user4.select)
   
    if @current_user.id == @room.user1
      @room.next = 0
      @room.save
      redirect_to("/rooms/:room_id/check")
    end
  end


end

def check
  if @room.number_of_players == 2
    redirect_to("/rooms/:room_id/announcement_two")
  elsif @room.number_of_players == 3
    redirect_to("/rooms/:room_id/announcement_three")
  elsif @room.number_of_players == 4
    redirect_to("/rooms/:room_id/announcement_four")
  end
end

def announcement_two
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

  redirect_to("/rooms/:room_id/announcement")
end

def announcement_three
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

  redirect_to("/rooms/:room_id/announcement")
end

def announcement_four
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

  redirect_to("/rooms/:room_id/announcement")
end

def announcement
end

def branch
  if User.find_by(room_id:session[:room_id],lottery:1)
    redirect_to("/drafts/:room_id/preparation")
  else
    redirect_to("/rooms/:room_id/result")
  end
end

def result
end

def chapter 
end

def next
  redirect_to("/rooms/:room_id/select")
end


end