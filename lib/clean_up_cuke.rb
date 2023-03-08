# frozen_string_literal: true

require_relative "clean_up_cuke/version"
require 'cucumber/runtime'
require 'cucumber/glue/registry'

module CleanUpCuke
  def self.find_unused_step_definitions
    unused_steps = []

    # Use Cucumber to find all feature files in the same directory or below
    feature_files = Dir.glob("**/*.feature")

    # Use Cucumber to perform a dry run of each feature file
    feature_files.each do |feature_file|
      runtime = Cucumber::Runtime.new
      runtime.configure(
        {
          paths: [feature_file], # Path to the feature test pack
          dry_run: true,         # Perform a dry run (don't execute steps)
          # support_to_load: ['functional-tests/features/step_definitions']
        },
        )

      runtime.send(:load_step_definitions)
      # Iterate over all step definitions and check if they were used
      runtime.send(:support_code).step_definitions.each do |step_definition|
        p step_definition
        if step_definition.match_locations.empty?
          # The step definition was not used
          unused_steps << "#{step_definition.regexp_source} (#{feature_file})"
        end
      end
    end

    # Return the array of unused step definitions
    unused_steps
  end
end

unused_steps = CleanUpCuke.find_unused_step_definitions
p unused_steps