require_relative 'scraper'
require_relative 'api_client'
require_relative 'reporter'

require_relative 'tester/all_cases'

class Tester
  def initialize(debug: false)
    @debug = debug
  end

  def test!(name)
    self.send(name)
  end

  private

  def report_issue(summary, description)
    reporter.post_issue(summary, description)
    puts "--- Issue Reported: #{summary} ---"
    return false
  end

  def scraper
    @scraper ||= Scraper.new(
      ENV.fetch('ORTRAX_WEB_ID'),
      ENV.fetch('ORTRAX_WEB_PASSWORD'),
      debug: @debug
    )
  end

  def api_client
    @api_client ||= ApiClient.new(ENV.fetch('ORTRAX_API_KEY'), debug: @debug)
  end

  def reporter(debug: @debug)
    @reporter ||= Reporter.new(
      ENV.fetch('JIRA_URL'),
      ENV.fetch('JIRA_ID'),
      ENV.fetch('JIRA_PASSWORD'),
      ENV.fetch('JIRA_PROJECT_KEY'),
      debug: debug
    )
  end
end
