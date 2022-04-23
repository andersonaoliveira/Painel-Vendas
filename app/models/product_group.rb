class ProductGroup < ApiModel
  attr_accessor :id, :name

  def initialize(id:, name:)
    @id = id
    @name = name
  end

  def self.all
    response = api_response('product_groups', '')
    result = []

    return nil unless response.status == 200

    product_groups = JSON.parse(response.body)
    product_groups.each do |p|
      result << ProductGroup.new(id: p['id'], name: p['name'])
    end

    result
  end

  def self.find(id)
    response = api_response('product_groups', "/#{id}")

    return nil unless response.status == 200

    p = JSON.parse(response.body)
    ProductGroup.new(id: p['id'], name: p['name'])
  end
end
