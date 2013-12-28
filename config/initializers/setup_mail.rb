if Rails.env.development?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => "app20657073@heroku.com",
    :password       => "5cg1syvq",
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }
end