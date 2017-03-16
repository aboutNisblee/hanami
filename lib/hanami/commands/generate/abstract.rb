require 'hanami/environment'
require 'hanami/commands/command'
require 'hanami/generators/generatable'
require 'hanami/generators/test_framework'
require 'hanami/generators/template_engine'
require 'hanami/version'
require 'hanami/utils/string'

module Hanami
  module Commands
    # @api private
    class Generate
      # @api private
      class Abstract < Commands::Command

        include Hanami::Generators::Generatable

        # @api private
        attr_reader :options
        # @api private
        attr_reader :target_path

        # @api private
        def initialize(options)
          super

          @options = Hanami::Utils::Hash.new(options).symbolize!
          assert_options!

          @target_path = Hanami.root
        end

        # @api private
        def template_source_path
          generator = self.class.name.split('::').last.downcase
          Pathname.new(::File.dirname(__FILE__) + "/../../generators/#{generator}/").realpath
        end

        private

        # @api private
        def test_framework
          @test_framework ||= Hanami::Generators::TestFramework.new(hanamirc, options[:test])
        end

        # @api private
        def hanamirc_options
          hanamirc.options
        end

        # @api private
        def hanamirc
          @hanamirc ||= Hanamirc.new(target_path)
        end

        # @api private
        def template_engine
          @template_engine ||= Hanami::Generators::TemplateEngine.new(hanamirc, options[:template])
        end

        # @api private
        def assert_options!
          if options.nil?
            raise ArgumentError.new('options must not be nil')
          end
        end

        # @since 1.0.0.beta1
        # @api private
        def project_name
          Utils::String.new(Hanami::Environment.new.project_name).underscore
        end
      end
    end
  end
end
