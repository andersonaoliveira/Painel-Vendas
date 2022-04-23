class Price < ApiModel
  attr_accessor :id, :value, :period

  def initialize(id:, value:, period:)
    @id = id
    @value = value
    @period = period
  end

  def self.all(plan_id)
    response = api_response('plans', "/#{plan_id}/prices")
    result = []

    return nil unless response.status == 200

    prices = JSON.parse(response.body)
    prices.each do |p|
      result << Price.new(id: p['id'], value: p['value'], period: p['period'])
    end

    result
  end

  def self.find_by(plan_id, period)
    response = api_response('plans', "/#{plan_id}/prices")

    result = []

    return nil unless response.status == 200

    prices = JSON.parse(response.body)
    prices.each do |p|
      result << Price.new(id: p['id'], value: p['value'], period: p['period']) if p['period'] == period
    end

    result[0]
  end
end
