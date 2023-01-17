require 'semantic'
module Fastlane
  module Actions

    class GetReleaseTagTitleAction < Action
      def self.run(params)
        target = Semantic::Version.new params[:version]
        
        if !params[:latest_release_tag]
          # we are on a new version, rc starts at 1
          # release_tag = "#{target}-rc.1"
          # release_tag = {tag: "#{target}-rc.1", title: "#{target} (RC1)"}
          rc_version = "1"
          
        else
          rc_version = params[:latest_release_tag].rpartition('.').last
          # we are on the same release, just update the rc
          rc_version = rc_version.to_i + 1
          # release_tag = {tag: "#{target}-rc.#{rc_version}", title: "#{target} (RC#{rc_version})"}
        end
        release_tag = {tag: "#{target}-rc.#{rc_version}", title: "#{target} (RC#{rc_version})"}
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :latest_release_tag, optional: true),
          FastlaneCore::ConfigItem.new(key: :version)
        ]
      end

      def self.is_supported?(platform)
       true
      end
    end
  end
end
