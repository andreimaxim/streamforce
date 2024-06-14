# frozen_string_literal: true

require "test_helper"

class TestStreamforce < ActiveSupport::TestCase
  test "host defaults to SALESFORCE_HOST env var or is set during initialization" do
    env_host = "test.salesforce.com"
    init_host = "login.salesforce.com"

    ENV["SALESFORCE_HOST"] = env_host

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new host: init_host

    assert_equal env_host, env_client.host
    assert_equal init_host, init_client.host
  end

  test "username defaults to SALESFORCE_USERNAME env var or is set during initialization" do
    env_username = "1234"
    init_username = "abcd"

    ENV["SALESFORCE_USERNAME"] = env_username

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new username: init_username

    assert_equal env_username, env_client.username
    assert_equal init_username, init_client.username
  end

  test "password defaults to SALESFORCE_PASSWORD env var or is set during initialization" do
    env_password = "1234"
    init_password = "abcd"

    ENV["SALESFORCE_PASSWORD"] = env_password

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new password: init_password

    assert_equal env_password, env_client.password
    assert_equal init_password, init_client.password
  end

  test "client_id defaults to SALESFORCE_CLIENT_ID env var or is set during initialization" do
    env_client_id = "1234"
    init_client_id = "abdc"

    ENV["SALESFORCE_CLIENT_ID"] = env_client_id

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new client_id: init_client_id

    assert_equal env_client_id, env_client.client_id
    assert_equal init_client_id, init_client.client_id
  end

  test "client_secret defaults to SALESFORCE_CLIENT_SECRET env var or is set during initialization" do
    env_client_secret = "1234"
    init_client_secret = "abcd"

    ENV["SALESFORCE_CLIENT_SECRET"] = env_client_secret

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new client_secret: init_client_secret

    assert_equal env_client_secret, env_client.client_secret
    assert_equal init_client_secret, init_client.client_secret
  end

  test "security_token defaults to SALESFORCE_SECURITY_TOKEN env var or is set during initialization" do
    env_security_token = "1234"
    init_security_token = "1234"

    ENV["SALESFORCE_SECURITY_TOKEN"] = init_security_token

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new security_token: init_security_token

    assert_equal env_security_token, env_client.security_token
    assert_equal init_security_token, init_client.security_token
  end

  test "api_version defaults to SALESFORCE_API_VERSION env var or is set during initialization" do
    env_api_version = "61.0"
    init_api_version = "58.0"

    ENV["SALESFORCE_API_VERSION"] = env_api_version

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new api_version: init_api_version

    assert_equal env_api_version, env_client.api_version
    assert_equal init_api_version, init_client.api_version
  end
end
