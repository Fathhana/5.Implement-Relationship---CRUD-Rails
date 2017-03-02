class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
      @user = User.new(params_user)
      if @user.save
          begin
              ConfirmationMailer.confirm_email("#{@user.email}", @user.activation_token).deliver
          rescue
              flash[:notice] = "activation instruction fails send to your email"
          end
          flash[:notice] = "activation instruction has send to #{@user.email}"
          redirect_to root_url
      else
          flash[:error] = "data not valid"
          render "new"
      end
  end


  private
      def params_user
        params.require(:user).permit(:username, :email, :password, :password_confirmation, :humanizer_answer, :humanizer_question_id)
      end
end
