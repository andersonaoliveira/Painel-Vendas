require 'rails_helper'

api_domain = Rails.configuration.apis['products_api']

RSpec.describe Plan, type: :model do
  it 'método find' do
    plan = '{"id": "3", "name": "Plano Z", "product_group": {"name": "Cloud"}}'
    resp_plan = Faraday::Response.new(status: 200, response_body: plan)
    allow(Faraday).to receive(:get).with("#{api_domain}/api/v1/plans/3").and_return(resp_plan)

    new_plan = Plan.find(3)

    expect(new_plan.id).to eq '3'
    expect(new_plan.name).to eq 'Plano Z'
  end

  it 'método where' do
    plans = '[{"id": "1", "name": "Plano X", "product_group": {"name": "Cloud"}},
             {"id": "2", "name": "Plano Y", "product_group": {"name": "Email"}},
             {"id": "3", "name": "Plano Z", "product_group": {"name": "Cloud"}}]'
    resp_plan = Faraday::Response.new(status: 200, response_body: plans)
    allow(Faraday).to receive(:get).with("#{api_domain}/api/v1/plans").and_return(resp_plan)

    result = Plan.where('Cloud')

    expect(result.length).to eq 2
    expect(result[0].name).to eq 'Plano X'
    expect(result[1].name).to include 'Plano Z'
  end
end
