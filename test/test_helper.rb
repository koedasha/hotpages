# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "hotpages"

# Fix the last modified date of the page to prevent failures
# during tests due to changes in CI, etc.
module PageMtimeStub
  def last_modified_at
    super && Time.new(2025, 9, 20)
  end
end
Hotpages::Extensions::PageMtime::Page.prepend(PageMtimeStub)

require "minitest/autorun"

class TestSite < Hotpages::Site
  config.site.root = Pathname.new(__dir__).join("test_site")
  config.site.dist_path = "../dist/actual"
  config.site.i18n.locales = %w[ ja en ]
  config.site.i18n.default_locale = "en"
end

Minitest.after_run do
  Hotpages.teardown
end
