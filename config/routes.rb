Rails.application.routes.draw do

  get '/' => 'home#top'
  
  post 'users/create' => 'users#create'
  post 'users/enter' => 'users#enter'
  post 'users/delete' => 'users#delete'
  post 'users/cancel' => 'users#cancel'
  get '/rooms/:room_id/matching' => 'rooms#matching'
  get '/rooms/:room_id/create' => 'rooms#create'
  post '/rooms/:room_id/create' => 'rooms#create'

  get '/rooms/:room_id/group' => 'rooms#group'
  post '/rooms/:room_id/group_confirm' => 'rooms#group_confirm'
  get '/rooms/:room_id/group_confirm' => 'rooms#group_confirm'
  
  get '/rooms/:room_id/meeting' => 'rooms#meeting'
  post '/rooms/:room_id/select' => 'rooms#select'
  get '/rooms/:room_id/select' => 'rooms#select'
  post '/rooms/:room_id/decide' => 'rooms#decide'
  get '/rooms/:room_id/wait' => 'rooms#wait'
  
  get '/rooms/:room_id/check' => 'rooms#check'
  get '/rooms/:room_id/announcement_two' => 'rooms#announcement_two'
  get '/rooms/:room_id/announcement_three' => 'rooms#announcement_three'
  get '/rooms/:room_id/announcement_four' => 'rooms#announcement_four'
  post '/rooms/:room_id/announcement' => 'rooms#announcement'
  get '/rooms/:room_id/announcement' => 'rooms#announcement'

  get '/rooms/:room_id/branch' => 'rooms#branch'
  get '/rooms/:room_id/result' => 'rooms#result'
  get '/rooms/:room_id/chapter' => 'rooms#chapter'
  post '/rooms/:room_id/next' => 'rooms#next'
  
  get '/drafts/:room_id/preparation' => 'drafts#preparation'
  get '/drafts/:room_id/lottery' => 'drafts#lottery'
  post '/drafts/:room_id/preparation_second' => 'drafts#preparation_second'
  get '/drafts/:room_id/preparation_second' => 'drafts#preparation_second'
  get '/drafts/:room_id/lottery_second' => 'drafts#lottery_second'
  post '/drafts/:room_id/second_select' => 'drafts#second_select'
  get '/drafts/:room_id/second_select' => 'drafts#second_select'
  post '/drafts/:room_id/second_decide' => 'drafts#second_decide'
  post '/drafts/:room_id/second_to_wait' => 'drafts#second_to_wait'
  get '/drafts/:room_id/second_wait' => 'drafts#second_wait'
  get '/drafts/:room_id/second_preparation' => 'drafts#second_preparation'
  
  get '/drafts/:room_id/second_check' => 'drafts#second_check'
  get '/drafts/:room_id/second_announcement_two' => 'drafts#second_announcement_two'
  get '/drafts/:room_id/second_announcement_three' => 'drafts#second_announcement_three'
  get '/drafts/:room_id/second_announcement_four' => 'drafts#second_announcement_four'
  post '/drafts/:room_id/second_announcement_go' => 'drafts#second_announcement_go'
  post '/drafts/:room_id/second_announcement' => 'drafts#second_announcement'
  get '/drafts/:room_id/second_announcement' => 'drafts#second_announcement'
  get '/drafts/:room_id/branch' => 'drafts#second_branch'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
