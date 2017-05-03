module Danger
  # This is your plugin class. Any attributes or methods you expose here will
  # be available from within your Dangerfile.
  #
  # To be published on the Danger plugins site, you will need to have
  # the public interface documented. Danger uses [YARD](http://yardoc.org/)
  # for generating documentation from your plugin source, and you can verify
  # by running `danger plugins lint` or `bundle exec rake spec`.
  #
  # You should replace these comments with a public description of your library.
  #
  # @example Ensure people are well warned about merging on Mondays
  #
  #          my_plugin.warn_on_mondays
  #
  # @see  /danger-circleci
  # @tags monday, weekends, time, rattata
  #
  class DangerCircleci < Plugin
    # Show links for the artifacts mentioned
    #
    # @param   [Array<String>] artifacts
    #          List of maps for the artifacts, using 'message' and 'path' keys
    # @return  [String]
    def artifacts_links(artifacts)
      return unless should_display_message

      message = ''

      artifacts.each do |artifact|
        title = artifact['message']
        link = artifact_link(artifact)

        message << "[#{title}](#{link})"
      end

      markdown message
    end

    # Checks if we can display the links to artifacts
    #
    # @return  [Boolean]
    def should_display_message
      cc_username && cc_project_name && cc_build_number && cc_node_index
    end

    private

    def cc_username
      ENV['CIRCLE_PROJECT_USERNAME']
    end

    def cc_project_name
      ENV['CIRCLE_PROJECT_NAME']
    end

    def cc_build_number
      ENV['CIRCLE_BUILD_NUM']
    end

    def cc_node_index
      ENV['CIRCLE_NODE_INDEX']
    end

    def circleci_url
      "https://circleci.com/api/v1/project/#{cc_username}/#{cc_project_name}" \
        "/#{cc_build_number}/artifacts/#{cc_node_index}"
    end

    def artifact_link(artifact)
      path = artifact['path'].sub('/', '')
      "#{circleci_url}/#{path}"
    end
  end
end
