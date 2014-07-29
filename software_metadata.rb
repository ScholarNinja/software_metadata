class SoftwareMetadata
  attr_accessor :cache

  def initialize
    @secrets = YAML.load_file('secrets.yml')

    @client = Faraday.new do |builder|
      builder.use :http_cache, serializer: Marshal
      builder.adapter Faraday.default_adapter
    end

    @cache ={}
  end

  def github(owner, repo)
    full_name = "#{owner}/#{repo}"
    data = if @cache[full_name]
      @cache[full_name]
    else
      @cache[full_name] = @client.get "https://api.github.com/repos/#{full_name}",
        {
          client_id: @secrets['github_client_id'],
          client_secret: @secrets['github_client_secret']
        }
    end
  end
end
