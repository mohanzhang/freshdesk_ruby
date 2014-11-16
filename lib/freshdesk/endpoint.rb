module Freshdesk
  #
  class Endpoint
    def helpdesk_path
      config.base_endpoint + '/helpdesk'
    end

    def ticket_path(id)
      path = File.join('/tickets', id.to_s) + '.json'
      helpdesk_path + path
    end

    def tickets_path(parameters = {})
      all_params = default_parameters.merge(parameters)
      query_string = '?' + all_params.to_query
      path = '/tickets/filter/all_tickets' + query_string
      helpdesk_path + path
    end

    def request_headers
      {
        'Content-Type' => 'application/json',
        'Authorization' => credentials
      }
    end

    def credentials
      encoded = Base64.strict_encode64(
        basic_auth_username + ':' + config.password
      )
      'Basic ' + encoded
    end

    def basic_auth_username
      # This supports the 2 ways of authenticating
      # with Freshdesk:
      # 1.) valid username and password
      # 2.) API key as the username with a dummy password
      config.username.empty? ? config.api_key : config.username
    end

    def config
      Freshdesk.configuration
    end

    def default_parameters
      {
        'format' => 'json'
      }
    end
  end
end
