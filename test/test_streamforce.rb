# frozen_string_literal: true

require "test_helper"

class TestStreamforce < Minitest::Test
  def test_host_setup
    env_host = "test.salesforce.com"
    init_host = "login.salesforce.com"

    ENV["SALESFORCE_HOST"] = env_host

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new host: init_host

    assert_equal env_host, env_client.host
    assert_equal init_host, init_client.host
  end

  def test_username_setup
    env_username = "1234"
    init_username = "abcd"

    ENV["SALESFORCE_USERNAME"] = env_username

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new username: init_username

    assert_equal env_username, env_client.username
    assert_equal init_username, init_client.username
  end

  def test_password_setup
    env_password = "1234"
    init_password = "abcd"

    ENV["SALESFORCE_PASSWORD"] = env_password

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new password: init_password

    assert_equal env_password, env_client.password
    assert_equal init_password, init_client.password
  end

  def test_client_id_setup
    env_client_id = "1234"
    init_client_id = "abdc"

    ENV["SALESFORCE_CLIENT_ID"] = env_client_id

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new client_id: init_client_id

    assert_equal env_client_id, env_client.client_id
    assert_equal init_client_id, init_client.client_id
  end

  def test_client_secret_setup
    env_client_secret = "1234"
    init_client_secret = "abcd"

    ENV["SALESFORCE_CLIENT_SECRET"] = env_client_secret

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new client_secret: init_client_secret

    assert_equal env_client_secret, env_client.client_secret
    assert_equal init_client_secret, init_client.client_secret
  end

  def test_security_token_setup
    env_security_token = "1234"
    init_security_token = "1234"

    ENV["SALESFORCE_SECURITY_TOKEN"] = init_security_token

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new security_token: init_security_token

    assert_equal env_security_token, env_client.security_token
    assert_equal init_security_token, init_client.security_token
  end

  def test_api_version_setup
    env_api_version = "61.0"
    init_api_version = "58.0"

    ENV["SALESFORCE_API_VERSION"] = env_api_version

    env_client = Streamforce::Client.new
    init_client = Streamforce::Client.new api_version: init_api_version

    assert_equal env_api_version, env_client.api_version
    assert_equal init_api_version, init_client.api_version
  end
end
