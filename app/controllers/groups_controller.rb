class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy]
  before_action :authenticate_user!
  def index
    @user = current_user
    @groups = @user.groups
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params.except(:icon))
    @group.author = current_user
    uploaded_icon = params[:group][:icon]
    if uploaded_icon.present?
      file_path = Rails.root.join('app', 'assets', 'images', uploaded_icon.original_filename)
      File.binwrite(file_path, uploaded_icon.read)
      @group.icon = uploaded_icon.original_filename
    end
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :icon)
  end
end
