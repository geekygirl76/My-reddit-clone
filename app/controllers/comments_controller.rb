class CommentsController < ApplicationController
  before_action :require_signed_in!, except: [:show, :index]

  def new
    if params[:comment_id].nil?
      @link = Link.find(params[:link_id])
      @comment = Comment.new
    else
      @parent_comment = Comment.find(params[:comment_id])
      @comment = Comment.new
    end
  end

  def create
    if params[:comment_id].nil?
      @link = Link.find(params[:link_id])
      @comment = @link.comments.new(comment_params)
      @comment.user_id = current_user.id
    else
      @parent_comment = Comment.find(params[:comment_id])
      @comment = @parent_comment.child_comments.new(comment_params)
      @comment.user_id = current_user.id
      @comment.link_id = @parent_comment.link_id
      @link = Link.find(@parent_comment.link_id)
    end

    if @comment.save
      redirect_to @link
    else
      flash[:errors] = @comment.errors.full_messages
      render :new
    end
  end


  def show
    @comment = Comment.find(params[:id])
    if @comment
      render :show
    else
      redirect_to subs_url
    end
  end


  private
  def comment_params
    params.require(:comment).permit(:content, :link_id, :user_id, :parent_comment_id)
  end
end
