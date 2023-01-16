module Fastlane
  module Actions
    module SharedValues
      VERSION = :VERSION
    end

    class GetReleaseVersionAction < Action
      def self.run(params)
        other_action.github_api(
          api_token: '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',
          http_method: 'GET',
          path: "/repos/january67/mobile_test/pulls/#{params[:pr_number]}"
        )
        
        Actions.lane_context[SharedValues::VERSION] = lane_context[SharedValues::GITHUB_API_JSON]["head"]["ref"].split("/").last
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
            env_name: 'BOT_PAT',
            description: 'Github PAT'),
          FastlaneCore::ConfigItem.new(key: :pr_number),

        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end