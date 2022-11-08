class Public::TagsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @name = params[:name]
    tag = Tag.find_by(name: @name)
    if tag.nill?
      redirect_to root_path: "##{@name}のタグがついた投稿は存在しません"
    else
      @posts = tag.posts.includes(:user, :post, :fovorites, :comments).recent
    end
  end
end
