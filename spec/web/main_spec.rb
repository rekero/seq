require_relative 'spec_helper'

describe '/main/disbursement' do
  it "should " do
    visit '/prefix1'
    page.title.must_equal 'Seq'
    # ...
  end
end
