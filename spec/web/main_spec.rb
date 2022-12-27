require_relative 'spec_helper'

describe '/main/disbursement' do
  let(:data) {
    [
      {:id=>1, :week_started_at=>Date.new(2018,1,1), :amount=>0.148867e4, :merchant_id=>9},
      {:id=>2, :week_started_at=>Date.new(2018,1,1), :amount=>0.264002e4, :merchant_id=>7},
      {:id=>3, :week_started_at=>Date.new(2018,1,1), :amount=>0.258587e4, :merchant_id=>14},
      {:id=>4, :week_started_at=>Date.new(2018,1,1), :amount=>0.278875e4, :merchant_id=>5},
      {:id=>5, :week_started_at=>Date.new(2018,1,1), :amount=>0.121455e4, :merchant_id=>1},
      {:id=>6, :week_started_at=>Date.new(2018,1,1), :amount=>0.353531e4, :merchant_id=>10},
      {:id=>7, :week_started_at=>Date.new(2018,1,1), :amount=>0.123229e4, :merchant_id=>13},
      {:id=>8, :week_started_at=>Date.new(2018,1,1), :amount=>0.221262e4, :merchant_id=>8},
      {:id=>9, :week_started_at=>Date.new(2018,1,1), :amount=>0.23102e4, :merchant_id=>12},
      {:id=>10, :week_started_at=>Date.new(2018,1,1), :amount=>0.208091e4, :merchant_id=>3}
    ]
  }

  let (:response) {
    {
      "disbursements":
        [
          {"9":1488.67},
          {"7":2640.02},
          {"14":2585.87},
          {"5":2788.75},
          {"1":1214.55},
          {"10":3535.31},
          {"13":1232.29},
          {"8":2212.62},
          {"12":2310.2},
          {"3":2080.91}
        ]
    }.to_json
  }

  let (:response_for_merchant) {
    {
      "disbursements":
        [
          {"9":1488.67}
        ]
    }.to_json
  }

  before(:all) do
    data.each do |part|
      DB[:disbursements].insert(part)
    end
  end

  after(:all) do
    DB[:disbursements].delete
  end

  it "should access all merchants for given week" do
    visit '/main/disbursements/?year=2018&month=1&day=1'

    assert page.has_content?(response)
  end


  it "should access all merchants for given week and given merchant" do
    visit '/main/disbursements/9?year=2018&month=1&day=1'

    puts page.body
    assert page.has_content?(response_for_merchant)
  end
end
