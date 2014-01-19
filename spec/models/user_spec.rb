require 'spec_helper'

# How does this result in passing validations?
# Is it the post validation that needs to pass?
# Does the validation not run until everything in the block runs?

describe User do

  describe ".top_rated" do
    before :each do
      post = nil
      topic = create(:topic)
      @u0 = create(:user) do |user| 
        post = user.posts.build(attributes_for(:post)) 
        post.topic = create(:topic)
        post.save
        comment = user.comments.build(attributes_for(:comment))
        comment.post = post
        comment.save
      end

      @u1 = create(:user) do |user|
        comment = user.comments.build(attributes_for(:comment))
        comment.post = post
        comment.save
        post = user.posts.build(attributes_for(:post)) 
        post.topic = create(:topic)
        post.save
        comment = user.comments.build(attributes_for(:comment))
        comment.post = post
        comment.save
      end
    end
  
    it "should return users based on comments + posts" do
      User.top_rated.should eq([@u1, @u0])
    end

    it "should have 'posts_count' on user" do
      users = User.top_rated
      users.first.posts_count.should eq(1)
    end

    it "should have 'comments_count' on user" do
      users = User.top_rated
      users.first.comments_count.should eq(2)
    end


  end
end

