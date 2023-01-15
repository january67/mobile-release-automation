module Fastlane
  module Actions
    module SharedValues
      LATEST_RC_VERSION = :LATEST_RC_VERSION 
      FOUND_MATCHING_VERSION_BOOL = :FOUND_MATCHING_VERSION_BOOL
    end

    class GetLatestReleaseAction < Action
      def self.run(params)
        
        other_action.github_api(
          api_token: params[:api_token],
          http_method: 'GET',
          path: '/repos/january67/mobile_test/releases?per_page=15'
        )
        release_list = lane_context[SharedValues::GITHUB_API_JSON]
        puts release_list.map { |entry| entry['tag_name'] }

        matches = release_list.map { |entry| entry['tag_name'] }.sort.reverse
        #d = matches.scan(params[:version])
        puts matches
        found_matching_version = matches.any?{|s| s[/#{params[:version]}/]}

        puts "--------"
        puts found_matching_version
        if found_matching_version
          lastest_rc_version = matches.find{|s| s[/#{params[:version]}/]}
          puts lastest_rc_version
          Actions.lane_context[SharedValues::LATEST_RC_VERSION] = lastest_rc_version
        end
        Actions.lane_context[SharedValues::FOUND_MATCHING_VERSION_BOOL] = found_matching_version
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
            env_name: 'BOT_PAT',
            description: 'Github PAT'),
          FastlaneCore::ConfigItem.new(key: :version),

        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
