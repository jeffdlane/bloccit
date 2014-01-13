class Users::RegistrationsController < Devise::RegistrationsController
  def update
    account_update_params = params[:user]
    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank? #how does this work?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params) #what is this?
      set_flash_message :notice, :updated #what is this
      # sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "devise/registrations/edit"
    end
  end
end
