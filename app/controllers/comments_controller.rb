class CommentsController < ApplicationController


  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:topic_id])
    @comment = Comment.new
  end
  end

def create
    @topic = Topic.find(params[:topic_id])
    @comment = current_user.comments.build(params[:comment])
    @post.topic = @topic
    @comment.post = @post
    @post = Post.find(params[:post_id])

    authorize! :create, @comment, message: "You need to be signed up to do that."
    if @comment.save
      flash[:notice] = "Comment was saved."
      redirect_to [@topic, @post]
    else
      flash[:error] = "There was an error saving the comment. Please try again."
      render :new
    end
  end
end
