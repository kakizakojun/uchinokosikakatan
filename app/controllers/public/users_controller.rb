class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]
  before_action :set_user, only: [:favorites]

  def index
    @users = User.all
    if user_signed_in?
      @user = current_user
      @favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
      @favorite_posts = Post.where(id: @favorites)
    end

    @posts = Post.includes(:user).where(users: {is_active: true}).where(user_id: [current_user.id, *current_user.following_ids]).order(created_at: :DESC)
    @notifications = current_user.passive_notifications.page(params[:page]).per(10)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end

    current_enties = current_user.entries
    my_room_id = []
    current_enties.each do |entry|
      my_room_id << entry.room.id
    end

    @another_enties = Entry.where(room_id: my_room_id).where.not(user_id: current_user.id)
  end

  def show
    if params[:id].to_i == current_user.id
      redirect_to mypage_path
    end
    if  user_signed_in?
      @user = User.find(params[:id])
      favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
      @favorite_posts = Post.find(favorites)
    end

    @user = User.find(params[:id])
    @posts = Post.includes(:user).order(created_at: :DESC).all
    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)

    unless @user.id == current_user.id
      @current_entry.each do |current|
        @another_entry.each do |another|
          if current.room_id == another.room_id
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if current_user.email != "guest@example.com"
      if @user.update(user_params)
        redirect_to mypage_path
        flash[:notice] = "編集を保存しました。"
      else
        flash[:alert] = "nameを入力してください"
        render :edit
      end
    else
      flash[:alert] = "ゲストユーザーの編集はできません。"
      render :edit
    end
  end

  def favorites
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :profile, :profile_image, :is_active)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(mypage_path) unless @user == current_user
  end




end
