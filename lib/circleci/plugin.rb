module Danger
  # Interact with CircleCI artifacts
  #
  # @example To show links to artifacts
  #
  #          artifacts = [
  #            {
  #              'title' => 'Test Report',
  #              'path' => "#{ENV['CIRCLE_TEST_REPORTS']}/test/report.html"
  #            },
  #            {
  #              'title' => 'Code Coverage Report',
  #              'path' => "#{ENV['CIRCLE_TEST_REPORTS']}/cov/index.html"
  #            }
  #          ]
  #          circleci.artifacts_links artifacts
  #
  #
  # @see  /danger-circleci
  # @tags circleci, build, artifacts
  #
  class DangerCircleci < Plugin
    # Show links for build artifacts
    #
    # @param   [Array<String>] artifacts
    #          List of maps for the artifacts, using 'message' and 'path' keys
    # @return  [String]
    def artifacts_links(artifacts)
      return unless should_display_message

      message = ''

      artifacts.each do |artifact|
        title = artifact['title']
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
