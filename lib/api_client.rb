require 'rest-client'
require 'json'

class ApiClient
  def initialize(key, debug: false)
    @debug = debug
    @token = key
  end

  def get_case(id)
    get("case?caseId=#{id}")
  end

  def verify_case(case_id, verified = true)
    post("/message/verify", {
        caseId: case_id,
        verified: verified
    })
  end

  private

  def post(path, payload)
    res = RestClient.post(
      "#{ENV.fetch('ORTRAX_API_URL')}/#{path}",
      payload,
      headers
    )
  end

  def get(path)
    res = RestClient.get(
      "#{ENV.fetch('ORTRAX_API_URL')}/#{path}",
      headers
    )

    JSON.parse(res.body)
  end

  def headers
    {
      accept: :json,
      content_type: :json,
      Authorization: "Token token=" + @token
    }
  end
end
