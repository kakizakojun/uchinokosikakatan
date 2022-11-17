class Public::PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save ? (redirect_to post_path(@post)) : (render :new)
  end

  def index
    @posts = Post.includes(:user).where(users: {is_active: true}).where(user_id: [current_user.id, *current_user.following_ids])
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params) ? (redirect_to post_path(@post)) : (render :edit)
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  def search
    @q = params[:q]

    @posts = Post.ransack(caption_cont: @q).result
    @users = User.ransack(name_cont: @q).result
  end

  private

  def post_params
    params.require(:post).permit(:caption, medias: [])
  end



end
