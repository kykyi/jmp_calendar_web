module Aws
    class LambdaClientError < StandardError; end

    class LambdaClient
      def self.call(lamdba_name, lambda_options)
        new(lamdba_name, lambda_options).call
      end

      def initialize(lambda_name, lambda_options)
        @lambda_name = lambda_name
        @lambda_options = lambda_options
      end

      def call
        lambda_response = invoke_lambda!

        parsed_response = JSON.parse(
          lambda_response.payload.read,
          symbolize_names: true
        )

        raise LambdaClientError, parsed_response[:body].to_s unless lambda_response.status_code == 200

        OpenStruct.new(
          {
            success?: parsed_response[:statusCode] == 200,
            payload: parsed_response[:body]
          }
        )
      end

      private

      attr_accessor :lambda_name, :lambda_options

      def invoke_lambda!
        @invoke_lambda ||= lambda_client.invoke(
          {
            function_name: "#{invocation[:function_name]}:#{invocation[:version]}",
            payload: lambda_options.to_json,
            invocation_type: 'RequestResponse'
          }
        )
      end

      def lambda_client
        Aws::Lambda::Client.new(
          access_key_id: config.access_key_id,
          secret_access_key: config.secret_access_key,
          region: config.region,
          http_read_timeout: config.http_read_timeout
        )
      end

      def invocation
        return @invocation if defined?(@invocation)

        @invocation = config.lambdas.find do |lambda|
          lambda[:name] == lambda_name
        end or raise LambdaClientError, "#{lambda_name} not found"
      end

      def config
        @config ||= Rails.application.config_for(:lambdas)
      end
    end
  end
