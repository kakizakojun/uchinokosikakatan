class Public::FavoritesController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    @favorite = current_user.favorites.new(post_id: post.id)
    @favorite.save
    post.create_notification_favorite!(current_user)
    render 'replace_btn'
  end

  def destroy
    post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_by(post_id: post.id)
    @favorite.destroy
    render 'replace_btn'
  end

end
