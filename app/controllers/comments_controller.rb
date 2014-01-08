class CommentsController < ApplicationController
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
    @comment = Comment.find(params[:id])
    @post = Post.find(params[:post_id])
    @topic = @post.topic
    authorize! :destroy, @comment, message: "You need to own the comment to delete it."
    if @comment.destroy
      redirect_to [@topic, @post], notice: "Comment was deleted."
    else
      flash[:error] = "There was an error deleting this comment."
      render 'posts/show'
    end
  end


end
