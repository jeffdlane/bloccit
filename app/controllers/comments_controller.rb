class CommentsController < ApplicationController
  respond_to :html, :js

  def new
  end

  def create
    @comment = current_user.comments.build(params[:comment])
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:post_id])
    @comment.post_id = @post.id
    authorize! :create, @comment, message: "You need to be signed up to do that."
    if @comment.save
      flash[:notice] = "Comment saved."
      redirect_to [@topic, @post]
    else
      flash[:error] = "Comment did not save."
      render 'posts/show'
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    authorize! :destroy, @comment, message: "You need to own the comment to delete it."
    if @comment.destroy
      flash[:notice] = "Comment was deleted."
    else
      flash[:error] = "There was an error deleting this comment."
    end
  
    respond_with(@comment) do |f|
      f.html { redirect_to [@topic, @post] }
    end
    
  end


end
