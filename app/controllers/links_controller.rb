class LinksController < ApplicationController
  before_action :require_signed_in!, only: [:new, :create]
  before_action :require_submitter, only: [:edit, :update, :destroy]

  def new

    @sub = Sub.find(params[:sub_id])
    @link = @sub.links.new
  end

  def create
    @sub = Sub.find(params[:sub_id])
    @link = @sub.links.new(link_params)

    @link.user_id = current_user.id

    if @link.save
      redirect_to link_url(@link)
    else
      flash[:errors] = @link.errors.full_messages
      render :new
    end
  end

  def edit
    render :edit
  end

  def update

    if @link.update_attributes(link_params)
      redirect_to @link
    else
      flash[:errors] = @link.errors.full_messages
      render :edit
    end
  end

  def show
    @link = Link.find(params[:id])
  end

  def index
    @link = Link.all
  end

  def destroy
    @link.destroy
    redirect_to sub_url(@link.sub_id)
  end

  def vote(direction)
    @link = Link.find(params[:id])
    @vote = Vote.find_by(user_id: current_user.id, value: direction, votable_id: @link.id, votable_type: "Link")
    if @vote
      flash[:errors] = ["You can not vote twice!"]
    else
      Vote.create!(user_id: current_user.id, value: direction, votable_id: @link.id, votable_type: "Link")
      @link.update_attributes(vote_value: @link.vote_value + direction)

    end

    redirect_to @link
  end

  def upvote
    vote(1)
  end

  def downvote
    vote(-1)
  end

  private
  def link_params
    params.require(:link).permit(:title, :url, :body, :link_id, :user_id, :vote_value)
  end

  def require_submitter
    @link = Link.find(params[:id])

    unless @link.user_id == current_user.id || current_user == @link.sub.moderator
      flash[:errors] = ["Only submitter of this link can implement this action!"]
      redirect_to link_url(@link)
    end

  end
end
