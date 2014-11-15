class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
   
  def set_locale
    if params[:locale]
      I18n.locale = params[:locale]
    else
      ip = request.remote_ip.to_s
      result = Geocoder.search(ip).first
      while result.nil?
        result = Geocoder.search(ip).first
      end
      @lat = result.latitude.to_i
      @long = result.longitude.to_i

      @is_english = (@long < -60 && @long > -130) && (@lat > 20 && @lat < 50 )

      unless @is_english
        I18n.locale = :ar
      end
    end
  end
end
