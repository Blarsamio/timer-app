module RequestSpecHelper
  def json
    parsed = JSON.parse(response.body)
    parsed.is_a?(Hash) && parsed['data'] ? parsed['data'] : parsed
  end

  def headers
    api_key = create(:api_key)
    { 'Authorization' => "Bearer #{api_key.key}" }
  end
end
