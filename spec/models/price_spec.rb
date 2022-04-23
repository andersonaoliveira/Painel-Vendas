require 'rails_helper'

api_domain = Rails.configuration.apis['products_api']

RSpec.describe Price, type: :model do
  it 'método all' do
    prices = '[{"id": "1", "period": "Mensal", "value": "50"},
               {"id": "2", "period": "Semestral", "value": "250"}]'
    resp_prices = Faraday::Response.new(status: 200, response_body: prices)
    allow(Faraday).to receive(:get).with("#{api_domain}/api/v1/plans/1/prices").and_return(resp_prices)

    result = Price.all(1)

    expect(result.length).to eq 2
    expect(result[0].period).to eq 'Mensal'
    expect(result[1].period).to eq 'Semestral'
  end

  it 'método find_by' do
    prices = '[{"id": "1", "period": "Mensal", "value": "50"}, {"id": "2", "period": "Semestral", "value": "250"}]'
    resp_prices = Faraday::Response.new(status: 200, response_body: prices)
    allow(Faraday).to receive(:get).with("#{api_domain}/api/v1/plans/1/prices").and_return(resp_prices)

    new_period = Price.find_by(1, 'Mensal')

    expect(new_period.id).to eq '1'
    expect(new_period.period).to eq 'Mensal'
  end
end
