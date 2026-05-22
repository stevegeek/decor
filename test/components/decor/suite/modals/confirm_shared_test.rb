# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Modals::ConfirmSharedTest < ActiveSupport::TestCase
  # Host class to exercise the mixin without depending on either Confirm or
  # ConfirmTemplate - the mixin is the smallest unit of behaviour and should
  # be testable in isolation.
  class Host
    include ::Decor::Suite::Modals::ConfirmShared
  end

  test "is a Module (mixin), not a Class" do
    assert_kind_of Module, ::Decor::Suite::Modals::ConfirmShared
    refute_kind_of Class, ::Decor::Suite::Modals::ConfirmShared
  end

  test "exposes VARIANT_ACCENT_CLASSES with a Suite token for every supported variant" do
    map = Host::VARIANT_ACCENT_CLASSES
    assert_equal [:info, :success, :warning, :danger, :destructive, :neutral].sort, map.keys.sort
    map.each_value { |cls| assert cls.is_a?(String) && cls.start_with?("decor:bg-"), "expected decor: prefix on #{cls.inspect}" }
  end

  test "destructive and danger accent map to the same suite-danger token (visual parity)" do
    assert_equal Host::VARIANT_ACCENT_CLASSES[:danger], Host::VARIANT_ACCENT_CLASSES[:destructive]
    assert_includes Host::VARIANT_ACCENT_CLASSES[:destructive], "suite-danger-500"
  end

  test "VARIANT_ICON_NAMES covers the five styled variants with heroicon-style names" do
    names = Host::VARIANT_ICON_NAMES
    assert_equal [:info, :success, :warning, :danger, :destructive].sort, names.keys.sort
    assert_equal "information-circle", names[:info]
    assert_equal "check-circle", names[:success]
    assert_equal "exclamation-triangle", names[:warning]
    assert_equal "exclamation-circle", names[:danger]
    assert_equal "trash", names[:destructive]
  end

  test "VARIANT_ICON_COLOR_CLASSES carries a decor:-prefixed text token for every variant" do
    map = Host::VARIANT_ICON_COLOR_CLASSES
    assert_equal [:info, :success, :warning, :danger, :destructive, :neutral].sort, map.keys.sort
    map.each_value { |cls| assert cls.start_with?("decor:text-"), "expected decor:text- prefix on #{cls.inspect}" }
  end

  test "destructive and danger icon colour map to the same suite-danger token" do
    assert_equal Host::VARIANT_ICON_COLOR_CLASSES[:danger], Host::VARIANT_ICON_COLOR_CLASSES[:destructive]
  end

  test "all maps are frozen (singletons - mutation would be a bug)" do
    assert ::Decor::Suite::Modals::ConfirmShared::VARIANT_ACCENT_CLASSES.frozen?
    assert ::Decor::Suite::Modals::ConfirmShared::VARIANT_ICON_NAMES.frozen?
    assert ::Decor::Suite::Modals::ConfirmShared::VARIANT_ICON_COLOR_CLASSES.frozen?
  end

  test "deliberately does NOT duplicate DESTRUCTIVE_HEADER/TITLE constants (owned by Suite::Modals::Modal)" do
    refute defined?(::Decor::Suite::Modals::ConfirmShared::DESTRUCTIVE_HEADER_CLASSES)
    refute defined?(::Decor::Suite::Modals::ConfirmShared::DESTRUCTIVE_TITLE_CLASSES)
  end
end
