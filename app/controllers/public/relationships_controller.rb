class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    @page_name = params[:from]
    @info_user = if params[:from] == "show"
      @user
    elsif params[:from] == "mypage"
      current_user
    end

    render 'replace_btn'
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    @page_name = params[:from]
    @info_user = if params[:from] == "show"
      @user
    elsif params[:from] == "mypage"
      current_user
    end

    render 'replace_btn'
  end

  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end

end
