class MiscController < ApplicationController
  before_filter :authenticate_user!
  
  def help
  end
end