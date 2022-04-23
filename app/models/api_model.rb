class ApiModel
  def self.api_response(endpoint, path)
    api_domain = Rails.configuration.apis['products_api']
    Faraday.get("#{api_domain}/api/v1/#{endpoint}#{path}")
  end
end
