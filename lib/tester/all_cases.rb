class Tester
  private

  def initialize(debug: true)
    @debug = debug
  end

  def all_cases
    get_all_cases.each do |kase|
      test_case!(kase)
      return if @debug # Only test 1 case.
    end
  end

  def test_case!(web_data)
    case_id = web_data[:id]
    puts "Fetching Case #{case_id} from the Api."
    issue = nil

    begin
      api_data = api_client.get_case(case_id)
    rescue RestClient::NotFound => rest_client_not_found
      issue = "Was not found in the Api.\n
               Web Data Dump:\n#{web_data}"
    end

    unless issue || cases_match_data?(web_data, api_data)
      issue = "Does not match the Api data\n
               Web Data Dump:\n#{web_data}\n
               API Data Dump:\n#{api_data}"
    end

    if issue.nil?
      puts "case #{case_id} verified!"
      api_client.verify_case(case_id, true)
    else
      # Failure
      puts "case #{case_id} NOT verified!"
      report_issue("Issue with Case #{case_id}", issue)
      api_client.verify_case(case_id, false)
    end
  end

  def cases_match_data?(web_data, api_data)
    # TODO Get case data matching between api and web.
    attr_map = [
      ['id', 'id']
    ]

    attr_map.each do |attributes|
      return false unless web_data[attributes[0]] == api_data[attributes[1]]
    end

    return true
  end

  def get_all_cases
    scraper.get_cases
  end
end
