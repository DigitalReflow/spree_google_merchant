# docs: https://support.google.com/merchants/answer/188494?hl=en


# Spree has no validation for uniqueness of its properties which ...leads to the code below.
# todo: Remove duplicate properties from database
# todo: clean up property usage
# todo: Add property uniqueness validations

google_merchant_product_category = Spree::Property.where(name: "google_merchant_product_category").first
google_merchant_brand            = Spree::Property.where(name: "google_merchant_brand").first
google_merchant_department       = Spree::Property.where(name: "google_merchant_department").first
google_merchant_color            = Spree::Property.where(name: "Colour").first
google_merchant_gtin             = Spree::Property.where(name: "google_merchant_gtin").first

category   = variant.product.product_properties.where(property_id: google_merchant_product_category.id).first if google_merchant_product_category
brand      = variant.product.product_properties.where(property_id: google_merchant_brand.id).first            if google_merchant_brand
department = variant.product.product_properties.where(property_id: google_merchant_department.id).first       if google_merchant_department
color      = variant.product.product_properties.where(property_id: google_merchant_color.id).first            if google_merchant_color
gtin       = variant.product.product_properties.where(property_id: google_merchant_gtin.id).first             if google_merchant_gtin


############## Required fields ################################################
xml.tag! 'g:title', "#{variant.product.name} #{variant_options variant}"
xml.tag! 'g:description', variant.product.description
xml.tag! 'link ', @production_domain + '/products/' + variant.product.slug
xml.tag! 'g:brand', (brand.try(:value) || 'Unbranded')
xml.tag! 'g:image_link', variant.product.images.first.attachment.url(:product) unless variant.product.images.empty?

# xml.tag! 'g:gtin', gtin.value
xml.tag! 'g:mpn', variant.sku.to_s # No current mpn is defined so using sku.
xml.tag! 'g:price', "#{variant.price} GBP"
xml.tag! 'g:id', variant.sku.to_s

# ...more hard coding. Both slow and brittle; changing the taxonomy name in any way will break this. :(
# todo: move this logic to the product class.
xml.tag! 'g:condition', variant.product.taxons.find { |t| t.name  == 'Pre-owned' } ? 'used' : 'new'

xml.tag! 'g:availability', Spree::Stock::Quantifier.new(variant).total_on_hand > 0 ? 'in stock' : 'out of stock'

# Hard coded free shipping to the UK only
xml.tag! 'g:shipping' do
  xml.tag! 'g:country', 'UK'
  xml.tag! 'g:service', 'Royal Mail'
  xml.tag! 'g:price', '0 GBP'
end

############## Optional fields #################################################
xml.tag! 'g:google_product_category', category.value if category
xml.tag! 'g:color', color.value if color

