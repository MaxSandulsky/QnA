class GistParseService
  attr_reader :content

  def initialize(url)
    @content = get_gist_content(url)
  end

  def get_gist_content(url)
    json = Octokit.gist(gist_id_from(url))
    parse_json_to_string_by(json, 'content')
  end

  def parse_json_to_string_by(json, _key)
    json['files'].first[1]['content']
  end

  def gist_id_from(url)
    url.gsub(%r{\A.+/{2}.+/.+/}, '')
  end
end
