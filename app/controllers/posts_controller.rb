class PostsController < ApplicationController

  before_filter :setup, :except => [:popular]

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    authorize! :read, @topic, message: "You need to be signed in to do that."
  end

  def new
    @post = Post.new
    authorize! :create, Post, message: "You need to be a member to create a new post."
  end

  def create
    @post = current_user.posts.build(params[:post])
    @post.topic = @topic

    authorize! :create, @post, message: "You need to be signed up to do that."
    if @post.save
      flash[:notice] = "Post was saved."
      redirect_to [@topic, @post]
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    authorize! :edit, @post, message: "You need to own the post to edit it."
  end

  def update
    @post = Post.find(params[:id])
    authorize! :update, @post, message: "You need to own the post to edit it."
    if @post.update_attributes(params[:post])
      flash[:notice] = "Post was updated."
      redirect_to [@topic,@post]
    else
      flash[:error] = "there was an error updating the post. Please try again."
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    name = @post.title
    authorize! :destroy, @post, message: "You need to own the post to delete it."
    if @post.destroy
      redirect_to @topic, notice: "\"#{name}\" was deleted."
    else
      flash[:error] = "There was an error deleting this post."
      render :show
    end
  end

  def popular
    @posts = Post.visible_to(current_user).where("posts.created_at > ?", 7.days.ago).paginate(page: params[:page], per_page:10)
  end

  def setup
    @topic = Topic.find(params[:topic_id])
  end

end