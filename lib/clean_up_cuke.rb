# frozen_string_literal: true

require_relative "clean_up_cuke/version"
require 'cucumber'
require 'pry'

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
          support_to_load: ['functional-tests/features/step_definitions']
        },
        )


      binding.pry
    end
  end
end

unused_steps = CleanUpCuke.find_unused_step_definitions
p unused_steps