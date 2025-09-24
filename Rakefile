# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

task default: :test

task "test:dist:replace_expected_with_actual" do
  unless Dir.exist?("test/dist/actual")
    raise "dist/actual is not exist"
  end

  rm_rf "test/dist/expected"
  mv "test/dist/actual", "test/dist/expected"
end
