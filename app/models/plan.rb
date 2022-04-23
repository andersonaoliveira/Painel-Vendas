class Plan < ApiModel
  attr_accessor :id, :name, :product_group

  def initialize(id:, name:, product_group:)
    @id = id
    @name = name
    @product_group = product_group
  end

  def self.find(id)
    response = api_response('plans', "/#{id}")

    return nil unless response.status == 200

    p = JSON.parse(response.body)
    Plan.new(id: p['id'], name: p['name'], product_group: p['product_group'])
  end

  def self.where(product_group)
    response = api_response('plans', '')

    result = []

    return nil unless response.status == 200

    plans = JSON.parse(response.body)
    plans.each do |p|
      if p['product_group']['name'] == product_group
        result << Plan.new(id: p['id'], name: p['name'], product_group: p['product_group'])
      end
    end

    result
  end
end
