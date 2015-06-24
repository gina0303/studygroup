class PostsController < ApplicationController

  def new
    @group = Group.find(params[:group_id])
    @post = @group.posts.new
  end
  
  def edit
  end
  
  def create
  end
  
  def update
  end
  
  def destroy
  end
end
