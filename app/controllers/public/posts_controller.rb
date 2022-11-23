class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_post, only:[:edit, :update]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if current_user.name != "ゲスト"
    @post.save ? (redirect_to post_path(@post)) : (render :new)
    else
      flash[:alert] = "新規投稿には新規登録またはログインが必要です"
      render :new
    end
  end

  def index
    @posts = Post.all.includes(:user).where(users: {is_active: true}).order(created_at: :DESC)
    # @posts = Post.includes(:user).where(users: {is_active: true})
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
    if @post.update(post_params)
      redirect_to post_path(@post)
      flash[:notice] = "編集を保存しました。"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to mypage_path, notice: "投稿を削除しました。"
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

  def correct_post
    @post = Post.find(params[:id])
    @user = @post.user
    redirect_to(mypage_path) unless @user == current_user
  end



end
