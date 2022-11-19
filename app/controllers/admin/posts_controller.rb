class Admin::PostsController < ApplicationController


  def index
    # @user = User.find(params[:user_id])
    # @posts = @user.posts
    @posts = Post.all.includes(:user).order(created_at: :DESC)

    # Post.where(user_id: user.id).includes(:user).order("create_at DEST")
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end


  private

  def post_params
    params.require(:post).permit(:caption, medias: [])
  end

end
