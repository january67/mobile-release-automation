module Fastlane
  module Actions
  
    class GetReleaseVersionAction < Action
      def self.run(params)
        other_action.github_api(
          api_token: params[:api_token],
          http_method: 'GET',
          path: "/repos/january67/mobile_test/pulls/#{params[:pr_number]}"
        )
        UI.user_error!('Failed to get pull request') if lane_context[SharedValues::GITHUB_API_STATUS_CODE] != 200

        version = lane_context[SharedValues::GITHUB_API_JSON]["head"]["ref"].split("/").last
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
          FastlaneCore::ConfigItem.new(key: :pr_number)

        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
