class CalculateDisbursementService
  SMALL_FEE = 1
  MEDIUM_FEE = 0.95
  LARGE_FEE = 0.85

  def self.call(date = nil)
    date ||= Date.today
    week_orders = DB[:orders].where{completed_at < date}.where{completed_at >= date - 7}
    data_hash = {}
    week_orders.each do |order|
      if data_hash[order[:merchant_id]].nil?
        data_hash[order[:merchant_id]] = calculate_amount_with_fee(order[:amount])
      else
        data_hash[order[:merchant_id]] += calculate_amount_with_fee(order[:amount])
      end
    end
    data_hash.keys.each do |merchant_id|
      DB[:disbursements].insert(
        merchant_id: merchant_id,
        amount: data_hash[merchant_id],
        week_started_at: date - 7
      )
    end
  end

  private

  def self.calculate_amount_with_fee(amount)
    if amount >= 300
      amount * (100 - LARGE_FEE) / 100
    elsif amount >= 50
      amount * (100 - MEDIUM_FEE) / 100    
    else
      amount * (100 - SMALL_FEE) / 100
    end
  end
end