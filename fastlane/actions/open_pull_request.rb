module Fastlane
  module Actions
    class OpenPullRequestAction < Action
      def self.run(params)
     
        other_action.create_pull_request(
          api_token: params[:api_token],
          repo: 'january67/mobile_test',
          title: "Release #{params[:rc_version]} (RC#{params[:rc_number]})",
          head: "release/#{params[:rc_version]}",
          base: 'releases',
          assignees: 'loyalBot',
          team_reviewers: ['change-review-board']
        )
        if lane_context[SharedValues::GITHUB_API_STATUS_CODE] != 201
          UI.user_error!("Failed to create pull request")
        end 

      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
            env_name: 'BOT_PAT',
            description: 'Github PAT'),
          FastlaneCore::ConfigItem.new(key: :rc_version),
          FastlaneCore::ConfigItem.new(key: :rc_number),
        ]
      end


      def self.is_supported?(platform)
       true
      end
    end
  end
end
