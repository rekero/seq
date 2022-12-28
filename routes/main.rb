class Seq
  hash_branch('main') do |r|
    r.on 'disbursements' do
      response['Content-Type'] = 'application/json'
      date = Date.new(r.params['year'].to_i, r.params['month'].to_i, r.params['day'].to_i)

      r.get Integer do |merchant_id|
        result = DB[:disbursements].where(merchant_id: merchant_id, week_started_at: date).map { |disbursement| { disbursement[:merchant_id] => disbursement[:amount].to_f } }
        { disbursements: result }.to_json
      end

      result = DB[:disbursements].where(week_started_at: date).map { |disbursement| { disbursement[:merchant_id] => disbursement[:amount].to_f } }

      { disbursements: result }.to_json
    end
  end
end
