class DemoController < ApplicationController
  def index
  end

  def protect
  end

  def log_out
    reset_session
    redirect_to '/'
  end
end
