class GroupsController < ApplicationController

  before_action :authenticate_user! 

  def index
  	@groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts
  end

  def new
  	@group = Group.new
  end
  
  def create
    @group = Group.new(group_params)
    if @group.save!
      current_user.join!(@group)
      flash[:notice] = "新增成功"
    else
      flash[:warning] = "新增失敗"
    end    
    redirect_to group_path(@group)
  end

def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本討論版成功！"
    else
      flash[:warning] = "你已經是本討論版成員了！"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出本討論版！"
    else
      flash[:warning] = "你不是本討論版成員，怎麼退出 XD"
    end

    redirect_to group_path(@group)
  end

  
  private
  
  def group_params 
      params.require(:group).permit(:title, :description)
  end
end

