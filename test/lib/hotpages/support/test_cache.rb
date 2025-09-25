# frozen_string_literal: true

require "test_helper"

class TestCache < Minitest::Test
  Entry = Hotpages::Support::Cache::Entry
  Store = Hotpages::Support::Cache::Store

  def test_entry_content_of_with_newer_version
    entry = Entry.new(version: 2, content: "cached content")

    assert_equal "cached content", entry.content_of(1)
    assert_equal "cached content", entry.content_of(2)
  end

  def test_entry_content_of_with_older_version
    entry = Entry.new(version: 1, content: "cached content")

    assert_nil entry.content_of(2)
  end

  def test_entry_content_of_with_nil_version
    entry = Entry.new(version: nil, content: "cached content")

    # nil version is considered as version 0
    assert_nil entry.content_of(1)
    assert_equal "cached content", entry.content_of(nil)
    assert_equal "cached content", entry.content_of(0)
  end

  def test_store_fetch
    store = Store.new
    key = "test cache key"

    result_v2 = store.fetch(key, version: 2) { "content version 2" }
    result = store.fetch(key, version: 1) { "content version 1" }

    # version 1 content shouldn't be fetched
    assert_equal result_v2, result

    # fething version 2 should return version 2 content
    assert_equal result_v2, store.fetch(key, version: 2)

    # fetching version 3 should return version 3 content
    result_v3 = store.fetch(key, version: 3) { "content version 3" }
    assert_equal "content version 3", result_v3

    # fetching newer content without block should return nil
    result_v4 = store.fetch(key, version: 4)
    assert_nil result_v4
  end
end
