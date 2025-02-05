module AuthHeaders
  def default_headers
    {
      "ACCEPT" => "application/json",
      "HTTP_AUTHORIZATION" => auth
    }
  end

  def auth
    ActionController::HttpAuthentication::Basic.encode_credentials(ENV.fetch("USER"), ENV.fetch("PASSWORD"))
  end

  def get(path, params: {}, headers: {}, **rest)
    super(path, params: params, headers: default_headers.merge(headers), **rest)
  end

  def post(path, params: {}, headers: {}, **rest)
    super(path, params: params, headers: default_headers.merge(headers), **rest)
  end

  def put(path, params: {}, headers: {}, **rest)
    super(path, params: params, headers: default_headers.merge(headers), **rest)
  end
end
