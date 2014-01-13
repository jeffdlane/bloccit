class TopicsController < ApplicationController
  def index
    @topics = Topic.visible_to(current_user).paginate(page: params[:page], per_page: 10)
  end

  def new
    @topic = Topic.new
    authorize! :create, Topic, message: "Only admins can create topics."
  end

  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      redirect_to @topic, notice: "Topic was saved successfully."
    else
      flash[:error] = "There was an error saving the topic. Please try again."
      render :new
    end
  end

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.paginate(page: params[:page], per_page: 10)
    authorize! :read, @topic, message: "You need to be signed in to do that."
  end

  def edit
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "You need to be an admin to do that."
  end

  def update
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "You need to own the topic to update it."
    if @topic.update_attributes(params[:topic])
      redirect_to @topic, notice: "Topic was updated successfully."
    else
      flash[:error] = "Error saving topic. Please try again."
      render :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    name = @topic.name
    authorize! :destroy, @topic, message: "You need to be a moderator or admin to destroy a topic."
    if @topic.destroy
      redirect_to topics_path, notice: "\"#{name}\" was destroyed."
    else
      flash[:error] = "There was an error destroying this topic."
      render :show
    end
  end
end
