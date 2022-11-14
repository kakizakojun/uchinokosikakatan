class Public::TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    @name = params[:tag]
    @tag = Tag.find_by(name: @name)
    if @tag.nil?
      flash[:alert] = "＃#{@name}のタグがついた投稿は存在しません"
      @posts = Post.all
    else
      @posts = @tag.posts
    end
  end
end
