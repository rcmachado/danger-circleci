require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerCircleci do
    it 'should be a plugin' do
      expect(Danger::DangerCircleci.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @circleci = @dangerfile.circleci
      end

      context 'environment variables not set' do
        before do
          allow(ENV).to receive(:[])
            .with('CIRCLE_PROJECT_USERNAME')
            .and_return('')
          allow(ENV).to receive(:[])
            .with('CIRCLE_PROJECT_NAME')
            .and_return('')
          allow(ENV).to receive(:[])
            .with('CIRCLE_BUILD_NUM')
            .and_return('')
          allow(ENV).to receive(:[])
            .with('CIRCLE_NODE_INDEX')
            .and_return('')
        end

        it 'should_display_message' do
          expect(@circleci.should_display_message).to be_empty
        end
      end

      context 'environment variables set' do
        before do
          allow(ENV).to receive(:[])
            .with('CIRCLE_PROJECT_USERNAME')
            .and_return('user')
          allow(ENV).to receive(:[])
            .with('CIRCLE_PROJECT_NAME')
            .and_return('project')
          allow(ENV).to receive(:[])
            .with('CIRCLE_BUILD_NUM')
            .and_return('123')
          allow(ENV).to receive(:[])
            .with('CIRCLE_NODE_INDEX')
            .and_return('1')
        end

        it 'should_display_message' do
          expect(@circleci.should_display_message).to be_truthy
        end

        describe 'artifacts_links' do
          it 'should format messages as links' do
            artifacts = [
              {
                'title' => 'Test artifact',
                'path' => '/tmp/my-file.txt'
              }
            ]

            @circleci.artifacts_links(artifacts)
            output = @circleci.status_report[:markdowns].first

            expect(output.message).to eq('[Test artifact](https://circleci.com/api/v1/project/user/project/123/artifacts/1/tmp/my-file.txt)')
          end
        end
      end
    end
  end
end
