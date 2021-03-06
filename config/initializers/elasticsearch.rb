require 'faraday_middleware/aws_sigv4'

def configure_elasticsearch
  if ENV['AWS_ELASTICSEARCH'] == 'true'
    aws_client
  else
    es_client
  end
end

def es_client
  Elasticsearch::Client.new log: ENV['ELASTICSEARCH_LOG']
end

def aws_client
  Elasticsearch::Client.new log: ENV['ELASTICSEARCH_LOG'],
                            url: ENV['ELASTICSEARCH_URL'] do |config|
    config.request :aws_sigv4,
                   credentials: Aws::Credentials.new(
                     ENV['AWS_ACCESS_KEY'],
                     ENV['AWS_SECRET_ACCESS_KEY']
                   ),
                   service: 'es',
                   region: ENV['AWS_REGION']
  end
end

Timdex::EsClient = configure_elasticsearch
