module Spree
  Product.class_eval do
    delegate_belongs_to :master, :google_merchant_gtin

    validates :google_merchant_brand, :length => { :maximum => 255 }
    validates :google_merchant_product_category, :length => { :maximum => 255 }
    validates :google_merchant_product_type, :length => { :maximum => 255 }
  end
end