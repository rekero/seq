every :monday, at: '1am' do
  runner "CalculateDisbursementService.call"
end