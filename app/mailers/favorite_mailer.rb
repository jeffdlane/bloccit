class FavoriteMailer < ActionMailer::Base
  default from: "mail.jeffdlane@gmail.com"

  def new_comment(user, post, comment)
    @user = user
    @post = post
    @comment = comment

    #New Headers
    headers["Message-ID"] = "<comments/#{@comment.id}@jeff-bloccit.herokuapp.com>"
    headers["In-Reply-To"] = "<post/#{@post.id}@jeff-bloccit.herokuapp.com>"
    headers["References"] = "<post/#{@post.id}@jeff-bloccit.herokuapp.com>"

    mail(to: user.email, subject: "New comment on #{post.title}")
  end
end
