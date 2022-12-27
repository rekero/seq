require_relative 'spec_helper'
require './services/calculate_disbursement_service'


describe CalculateDisbursementService do

  let(:data) {
    [
      {:id=>3, :merchant_id=>7, :shopper_id=>125, :amount=>0.4455e3, :created_at=>Time.parse('2018-01-01 02:51:00 +0400'), :completed_at=>nil},
      {:id=>8, :merchant_id=>9, :shopper_id=>325, :amount=>0.19061e3, :created_at=>Time.parse('2018-01-01 07:36:00 +0400'), :completed_at=>nil},
      {:id=>16, :merchant_id=>2, :shopper_id=>77, :amount=>0.32699e3, :created_at=>Time.parse('2018-01-01 15:12:00 +0400'), :completed_at=>nil},
      {:id=>17, :merchant_id=>2, :shopper_id=>15, :amount=>0.22403e3, :created_at=>Time.parse('2018-01-01 16:09:00 +0400'), :completed_at=>nil},
      {:id=>4, :merchant_id=>9, :shopper_id=>11, :amount=>0.18536e3, :created_at=>Time.parse('2018-01-01 03:48:00 +0400'), :completed_at=>Time.parse('2018-01-03 01:59:56 +0400')},
      {:id=>5, :merchant_id=>7, :shopper_id=>354, :amount=>0.4153e3, :created_at=>Time.parse('2018-01-01 04:45:00 +0400'), :completed_at=>Time.parse('2018-01-03 05:13:16 +0400')},
      {:id=>6, :merchant_id=>14, :shopper_id=>217, :amount=>0.18844e3, :created_at=>Time.parse('2018-01-01 05:42:00 +0400'), :completed_at=>Time.parse('2018-01-02 18:03:55 +0400')},
      {:id=>7, :merchant_id=>7, :shopper_id=>288, :amount=>0.6599e2, :created_at=>Time.parse('2018-01-01 06:39:00 +0400'), :completed_at=>Time.parse('2018-01-02 16:41:25 +0400')},
      {:id=>9, :merchant_id=>5, :shopper_id=>87, :amount=>0.41977e3, :created_at=>Time.parse('2018-01-01 08:33:00 +0400'), :completed_at=>Time.parse('2018-01-03 04:11:46 +0400')},
      {:id=>10, :merchant_id=>1, :shopper_id=>86, :amount=>0.5933e2, :created_at=>Time.parse('2018-01-01 09:30:00 +0400'), :completed_at=>Time.parse('2018-01-03 01:02:43 +0400')},
      {:id=>12, :merchant_id=>14, :shopper_id=>388, :amount=>0.31682e3, :created_at=>Time.parse('2018-01-01 11:24:00 +0400'), :completed_at=>Time.parse('2018-01-03 22:57:39 +0400')},
      {:id=>13, :merchant_id=>10, :shopper_id=>110, :amount=>0.37713e3, :created_at=>Time.parse('2018-01-01 12:21:00 +0400'), :completed_at=>Time.parse('2018-01-03 15:16:48 +0400')},
      {:id=>14, :merchant_id=>13, :shopper_id=>122, :amount=>0.4735e2, :created_at=>Time.parse('2018-01-01 13:18:00 +0400'), :completed_at=>Time.parse('2018-01-03 13:01:58 +0400')},
      {:id=>15, :merchant_id=>13, :shopper_id=>206, :amount=>0.28497e3, :created_at=>Time.parse('2018-01-01 14:15:00 +0400'), :completed_at=>Time.parse('2018-01-02 18:48:28 +0400')},
      {:id=>18, :merchant_id=>13, :shopper_id=>16, :amount=>0.10934e3, :created_at=>Time.parse('2018-01-01 17:06:00 +0400'), :completed_at=>Time.parse('2018-01-04 09:14:58 +0400')},
      {:id=>20, :merchant_id=>5, :shopper_id=>353, :amount=>0.36713e3, :created_at=>Time.parse('2018-01-01 19:00:00 +0400'), :completed_at=>Time.parse('2018-01-03 11:46:44 +0400')},
      {:id=>21, :merchant_id=>10, :shopper_id=>328, :amount=>0.28722e3, :created_at=>Time.parse('2018-01-01 19:57:00 +0400'), :completed_at=>Time.parse('2018-01-03 00:33:58 +0400')},
      {:id=>22, :merchant_id=>8, :shopper_id=>327, :amount=>0.28871e3, :created_at=>Time.parse('2018-01-01 20:54:00 +0400'), :completed_at=>Time.parse('2018-01-03 20:05:47 +0400')},
      {:id=>23, :merchant_id=>12, :shopper_id=>364, :amount=>0.17246e3, :created_at=>Time.parse('2018-01-01 21:51:00 +0400'), :completed_at=>Time.parse('2018-01-04 07:38:03 +0400')}
    ]
  }

  before(:all) do
    data.each do |part|
      DB[:orders].insert(part)
    end
  end

  after(:all) do
    DB[:disbursements].delete
  end

  it "should calculate disbursements" do
    obj = CalculateDisbursementService
    first_order_date = Order.exclude(completed_at: nil).first[:completed_at]
    next_week_start_diff = (8 - first_order_date.wday) % 8
    next_week_start = first_order_date.to_date.next_day(next_week_start_diff)
    obj.call(next_week_start)
    Disbursement.first[:amount].must_equal(183.6)
  end
end