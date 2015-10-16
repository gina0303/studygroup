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

  def edit
    @group = current_user.groups.find(params[:id])
  end

  def update
    @group = current_user.groups.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path, notice: "修改討論版成功"
    else
      render :edit
    end
  end
  
  def create
    @group = current_user.groups.new(group_params)
    if @group.save!
      current_user.join!(@group)
      flash[:notice] = "新增成功"
    else
      flash[:warning] = "新增失敗"
    end    
    redirect_to group_path(@group)
  end

  def destroy
    @group = current_user.groups.find(params[:id])
    @group.destroy
    redirect_to groups_path, alert: "討論版已刪除"   
  end

def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入讀書會成功！"
    else
      flash[:warning] = "你已經是本讀書會成員了！"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出讀書會！"
    else
      flash[:warning] = "你不是讀書會成員，怎麼退出 XD"
    end

    redirect_to group_path(@group)
  end

  
  private
  
  def group_params 
      params.require(:group).permit(:title, :description)
  end
end

