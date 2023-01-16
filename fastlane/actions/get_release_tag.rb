require 'semantic'
module Fastlane
  module Actions
    module SharedValues
      NEXT_RELEASE_TAG = :NEXT_RELEASE_TAG
    end

    class GetReleaseTagAction < Action
      def self.run(params)
        target = Semantic::Version.new params[:version]
        
        if !params[:found_matching_version]
          # we are on a new version, rc starts at 1
          release_tag = "#{target}-rc.1"
          
        else
          rc_version = params[:latest_release_tag].rpartition('.').last
          # we are on the same release, just update the rc
          rc_version = rc_version.to_i + 1
          release_tag = "#{target}-rc.#{rc_version}"
        end
        Actions.lane_context[SharedValues::NEXT_RELEASE_TAG] = release_tag

        puts Actions.lane_context[SharedValues::NEXT_RELEASE_TAG]
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :latest_release_tag, optional: true),
          FastlaneCore::ConfigItem.new(key: :version),
          FastlaneCore::ConfigItem.new(key: :found_matching_version, is_string: false),
        ]
      end

      def self.is_supported?(platform)
       true
      end
    end
  end
end
