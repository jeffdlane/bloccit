class TopicsController < ApplicationController
  def index
    @topic = Topic.all
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
    @posts = @topic.posts
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
end
