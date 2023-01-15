module Fastlane
  module Actions
    class MergeRcPrAction < Action
      def self.run(params)
        UI.message "Automobot attempting to merge pr number - #{params[:pr_number]}"

        body = JSON.generate({'merge_method' => 'merge'})
    
        github_api(
          api_token: params[:api_token],
          http_method: 'PUT',
          path: "/repos/january67/mobile_test/pulls/#{params[:pr_number]}/merge",
          body: body
        )
    
        if lane_context[SharedValues::GITHUB_API_STATUS_CODE] != 200
          UI.user_error!('Failed to merge pull request')
        end
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
            env_name: 'BOT_PAT',
            description: 'Github PAT'),
          FastlaneCore::ConfigItem.new(key: :pr_number,
            description: 'Number of RC PR to merge'),
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
