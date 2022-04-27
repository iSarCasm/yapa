class ApplicationController < ActionController::Base
  include Pundit
  include ConfigureDeviseParameters
end
