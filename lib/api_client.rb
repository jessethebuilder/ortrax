require 'rest-client'
require 'json'

class ApiClient
  URL_ROOT = 'http://v2.ortrax.com/dev'

  def initialize(key, debug: true)
    @token = key
  end

  def get_case(id)
    get("case?caseId=#{id}")
  end

  private

  def get(path)
    res = RestClient.get(
      "#{URL_ROOT}/#{path}",
      {
        accept: :json,
        content_type: :json,
        Authorization: "Token token=" + @token
      }
    )

    JSON.parse(res.body)
  end
end
