class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    puts resource_name.inspect
    puts controller_path
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    render :status => 200, :json => { :session => { :error => "Success", :auth_token => current_user.authentication_token } }
  end

  def destroy
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    current_user.authentication_token = nil
    render :json => {}.to_json, :status => :ok
  end
end
