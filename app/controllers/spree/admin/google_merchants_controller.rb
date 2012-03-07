module Spree
  class Admin::GoogleMerchantsController < Admin::BaseController

    def update
      Spree::GoogleMerchant::Config.set(params[:preferences])

      respond_to do |format|
        format.html {
          redirect_to admin_google_merchants_path
        }
      end
    end

  end
end