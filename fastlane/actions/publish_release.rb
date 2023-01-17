module Fastlane
  module Actions
    class PublishReleaseAction < Action
      def self.run(params)

        release_tag_title = other_action.get_release_tag_title(
          latest_release_tag: params[:latest_release_tag],
          version: params[:version]
        )

        body = JSON.generate({
          'tag_name' => "#{release_tag_title[:tag]}",
          'name' => "#{release_tag_title[:title]}",
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
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
            env_name: 'BOT_PAT',
            description: 'Github PAT'),
          FastlaneCore::ConfigItem.new(key: :latest_release_tag),
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
