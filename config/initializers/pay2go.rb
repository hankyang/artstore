Pay2go.setup do |pay2go|
  if Rails.env.development?
    pay2go.merchant_id = ENV['pay2go_merchant_id']  # 放測試站的 key

    pay2go.hash_key    = ENV['pay2go_merchant_key']
    pay2go.hash_iv     = ENV['pay2go_merchant_iv']
    pay2go.service_url = ENV['pay2go_merchant_url']
  else
    pay2go.merchant_id = ENV['pay2go_merchant_id']  # 放正式站的 key

    pay2go.hash_key    = ENV['pay2go_merchant_key']
    pay2go.hash_iv     = ENV['pay2go_merchant_iv']
    pay2go.service_url = ENV['pay2go_merchant_url']
  end
end