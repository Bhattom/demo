class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :destroy, :update]
  after_action :message, only: [:create, :update, :destroy]
  after_action :send_welcome_email
  
  def index
    @users = User.all
    respond_to do |format|
      format.html do
        @users = User.order(created_at: :desc)
      end
      format.csv { send_data User.to_csv, filename: "users.csv"}
    end
     @q = User.ransack(params[:q]) 
     @users = @q.result(distinct: true)
     @users = @users.all.page params[:page]
  end

  
  def show
  end

 
  def new
    @user = User.new
    puts "@user: #{@user.inspect}"
  end

  
  def edit
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        UserMailer.with(user: @user).welcome_email.deliver_now
        format.html { redirect_to user_url(@user), notice: "User is successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!
    session[:user_id] = nil
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  def recover
    @user = User.only_deleted.find(params[:id])
    @user.recover
    redirect_to user_path, notice: 'Record recovered successfully.'
  end
  def download_pdf
    user = User.find(params[:id])
    send_data generate_pdf(user),
              filename: "#{user.name}.pdf",
              type: "application/pdf"
  end
  

  private
    def set_user
      @user = User.find(params[:id])
    end
    def user_params
      params.require(:user).permit(:name, :email, :login, :name_cont)
    end
    def message
      Rails.logger.info("user action completed successfully!!..")
    end
    def generate_pdf(user)
      Prawn::Document.new do
        text user.name, align: :center
        text "Email: #{user.email}"
        text "Login: #{user.login}"
      end.render
    end
    def send_welcome_email
      SendEmailsJob.perform_now(@user)
      end
end
