module Fastlane
  module Actions
    class PublishReleaseAction < Action
      def self.run(params)
        
        body = JSON.generate({
          'tag_name' => "#{lane_context[SharedValues::NEXT_RELEASE_TAG]}",
          'name' => "#{params[:version]} (RC#{lane_context[SharedValues::NEXT_RELEASE_TAG].split(".").last})",
          'target_commitish' => 'releases',
          'generate_release_notes' => true
          })

          other_action.github_api(
            api_token: params[:api_token],
            http_method: 'POST',
            path: "#{params[:repo_path]}/releases",
            body: body
          )
        
          if lane_context[SharedValues::GITHUB_API_STATUS_CODE] != 201
            UI.user_error!("Failed to create release")
          end
      end


      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
            env_name: 'BOT_PAT',
            description: 'Github PAT'),
          FastlaneCore::ConfigItem.new(key: :next_release_tag),
          FastlaneCore::ConfigItem.new(key: :version),
          FastlaneCore::ConfigItem.new(key: :repo_path)
        ]
      end


      def self.is_supported?(platform)
       true
      end
    end
  end
end
