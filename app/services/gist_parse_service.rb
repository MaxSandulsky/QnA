class GistParseService
  attr_reader :content

  def initialize(url)
    @content = get_gist_content(url)
  end

  def get_gist_content(url)
    response = json_responce(url).get()
    parse_json_to_string_by(response.body, 'content')
  end

  def parse_json_to_string_by(json, key)
    json["files"][json["files"].keys[0]]["content"]
  end

  def json_responce(url)
    Faraday.new(url: url) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.response :json
    end
  end
end
