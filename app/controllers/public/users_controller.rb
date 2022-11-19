class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]
  before_action :set_user, only: [:favorites]

  def index
    @users = User.all
    if user_signed_in?
      @user = current_user
      favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
      @favorite_posts = Post.find(favorites)
    end
    @posts = Post.includes(:user).where(users: {is_active: true}).where(user_id: [current_user.id, *current_user.following_ids]).order(created_at: :DESC)
  end

  def show
    if  user_signed_in?
      @user = User.find(params[:id])
      favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
      @favorite_posts = Post.find(favorites)
    end
    @posts = Post.includes(:user).order(created_at: :DESC)
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to mypage_path
    else
      render "edit"
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
