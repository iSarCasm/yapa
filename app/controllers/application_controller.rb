class ApplicationController < ActionController::Base
  include Pundit
  include ConfigureDeviseParameters
  include RedirectAfterSignIn
end
