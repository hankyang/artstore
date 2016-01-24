Pay2go.setup do |pay2go|
  if Rails.env.development?
    pay2go.merchant_id = "31410425"  # 放測試站的 key

    pay2go.hash_key    = "DTcoc9lYR2Mn4CSad2ZNwgMOCkrJy3Wc"
    pay2go.hash_iv     = "W8B8hW79ZTx3wpeJ"
    pay2go.service_url = "https://capi.pay2go.com/MPG/mpg_gateway"
  else
    pay2go.merchant_id = "31410425"  # 放正式站的 key

    pay2go.hash_key    = "DTcoc9lYR2Mn4CSad2ZNwgMOCkrJy3Wc"
    pay2go.hash_iv     = "W8B8hW79ZTx3wpeJ"
    pay2go.service_url = "https://api.pay2go.com/MPG/mpg_gateway"
  end
end