class SubsController < ApplicationController
  before_action :require_signed_in!, except: [:index, :show]
  before_action :require_moderator, only: [:update, :edit, :destroy]

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = current_user.subs.new(sub_params)

    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = Sub.find(params[:id])

    render :edit

  end

  def update


    if @sub.update_attributes(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def show
    @sub = Sub.find(params[:id])

    render :show
  end

  def index
    @subs = Sub.all
    render :index
  end

  def destroy

    @sub.destroy
    redirect_to subs_url
  end

  private
  def sub_params
    params.require(:sub).permit(:title,:description,:moderator)
  end

  def require_moderator
    @sub = Sub.find(params[:id])
    unless @sub.moderator == current_user
      flash[:errors] = ["This is not a sub created by you!"]

      redirect_to sub_url(@sub)
    end
  end
end
