class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    if current_user.email != "guest@example.com"
      @user = User.find(params[:user_id])
      current_user.follow(@user)
      @page_name = params[:from]
      @info_user = if params[:from] == "show"
        @user
      elsif params[:from] == "mypage"
        current_user
      end
      render 'replace_btn'
      @user.create_notification_follow!(current_user)
    else
      flash[:alert] = "フォローするには新規登録、ログインが必要です。"
      redirect_to :mypage
    end
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
