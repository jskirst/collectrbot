class MiscController < ApplicationController
  before_filter :authenticate_user!
  
  def help
    @left_panel = :help
  end
end