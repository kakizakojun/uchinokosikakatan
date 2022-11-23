class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "ユーザーの編集を保存しました。"
      redirect_to admin_user_path(@user.id)
    else
      render edit
    end
  end



  private

  def user_params
    params.require(:user).permit(:name, :profile, :is_active, :is_deleted)
  end


end
