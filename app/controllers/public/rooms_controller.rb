class Public::RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    if current_user.email != "guest@example.com"
      room = Room.create
      current_entry = Entry.create(user_id: current_user.id, room_id: room.id)
      another_entry = Entry.create(user_id: params[:entry][:user_id], room_id: room.id)
      redirect_to room_path(room)
    else
      flash[:alert] = "メッセージをするには新規登録またはログインが必要です"
      redirect_to mypage_path
    end
  end

  def index
      current_enties = current_user.entries
      my_room_id = []
      current_enties.each do |entry|
        my_room_id << entry.room.id
      end
      @another_enties = Entry.where(room_id: my_room_id).where.not(user_id: current_user.id)
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.all
    @message = Message.new
    @entries = @room.entries
    @another_entry = @entries.where.not(user_id: current_user.id).first
  end
end
