require 'rails_helper'

api_domain = Rails.configuration.apis['products_api']

RSpec.describe ProductGroup, type: :model do
  it 'método all' do
    product_groups = '[{"id": "1", "name": "Hospedagem"},
                       {"id": "2", "name": "Cloud"}]'
    resp_pgs = Faraday::Response.new(status: 200, response_body: product_groups)
    allow(Faraday).to receive(:get).with("#{api_domain}/api/v1/product_groups").and_return(resp_pgs)

    result = ProductGroup.all

    expect(result.length).to eq 2
    expect(result[0].name).to eq 'Hospedagem'
    expect(result[1].name).to eq 'Cloud'
  end

  it 'método find' do
    product_group = '{"id": "2", "name": "Cloud"}'
    resp_pg = Faraday::Response.new(status: 200, response_body: product_group)
    allow(Faraday).to receive(:get).with("#{api_domain}/api/v1/product_groups/2").and_return(resp_pg)

    new_pg = ProductGroup.find(2)

    expect(new_pg.id).to eq '2'
    expect(new_pg.name).to eq 'Cloud'
  end
end
