# frozen_string_literal: true

module Aws
  class S3SpreadsheetClient
    def self.call(bucket, key)
      new(bucket, key).call
    end

    def initialize(bucket, key)
      @bucket = bucket
      @key = key
    end

    def call
      s3 = Aws::S3::Client.new(
        access_key_id: config.access_key_id,
        secret_access_key: config.secret_access_key,
        region: config.region
      )
      obj = s3.get_object(bucket: bucket, key: key)

      xlsx = Roo::Excelx.new(StringIO.new(obj.body.read))

      OpenStruct.new(
        {
          xlsx: xlsx
        }
      )
    end

    private

    attr_accessor :bucket, :key

    def config
      @config ||= Rails.application.config_for(:s3)
    end
  end
end
