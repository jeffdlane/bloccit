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
end
