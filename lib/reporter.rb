require 'rest_client'
require 'base64'
require 'json'

class Reporter
  def initialize(site_url, username, password, project_key, debug: false)
    @debug = debug
    @base_url = "#{site_url}/rest/api/2"
    @username = username
    @password = password
    @project_key = project_key
  end

  def get_projects
    get '/project'
  end

  def post_issue(summary, description)
    post(
      "issue",
      {
        fields: {
          project: {
            key: @project_key
          },
          summary: "ORTRAX ALL CASES: #{summary}",
          description: description,
          issuetype: {
            id: '10005'
          }
        }
      }
    )
  end

  def issue_meta
    get "issue/createmeta"
  end

  private

  def get(path)
    RestClient.get(
      "#{@base_url}/#{path}",
      {
        'Authorization' => "Basic #{token}",
        'Content-Type' => 'application/json'
      }
    )
  end

  def post(path, payload)
    RestClient.post(
      "#{@base_url}/#{path}",
      payload.to_json,
      {
        'Authorization' => "Basic #{token}",
        # accept: :json,
        'Content-Type' => 'application/json',
        # 'accept' => 'application/json'
      }
    )
  end

  def token
    Base64.encode64("#{@username}:#{@password}")
  end

  # def client
  #   # opts = {
  #   #   username: @username,
  #   #   token: @token,
  #   #   site: @url,
  #   #   context_path: @context_path,
  #   #   auth_type: :basic,
  #   #   read_timeout: 120,
  #   #   use_ssl: false,
  #   #   ssl_verify_mode: :none
  #   # }
  #   opts = {
  #     :site               => 'http://localhost:2990',
  #     :context_path       => '/jira',
  #     :signature_method   => 'RSA-SHA1',
  #     :request_token_path => "/plugins/servlet/oauth/request-token",
  #     :authorize_path     => "/plugins/servlet/oauth/authorize",
  #     :access_token_path  => "/plugins/servlet/oauth/access-token",
  #     :private_key_file   => "rsakey.pem",
  #     :rest_base_path     => "/rest/api/2",
  #     :consumer_key       => "jira-ruby-example"
  #   }
  #
  #   @client ||= JIRA::Client.new(opts)
  # end
end
