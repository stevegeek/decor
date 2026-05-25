# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Modals::ConfirmTest < ActiveSupport::TestCase
  test "inherits from Components::Modals::Confirm" do
    assert ::Decor::Suite::Modals::Confirm.new(title: "T", message: "M").is_a?(::Decor::Components::Modals::Confirm)
  end

  test "title is required" do
    assert_raises(ArgumentError) do
      ::Decor::Suite::Modals::Confirm.new(message: "M")
    end
  end

  test "message is required" do
    assert_raises(ArgumentError) do
      ::Decor::Suite::Modals::Confirm.new(title: "T")
    end
  end

  test "defaults variant to :info, confirm_label to Confirm, cancel_label to Cancel" do
    c = ::Decor::Suite::Modals::Confirm.new(title: "T", message: "M")
    assert_equal :info, c.instance_variable_get(:@variant)
    assert_equal "Confirm", c.instance_variable_get(:@confirm_label)
    assert_equal "Cancel", c.instance_variable_get(:@cancel_label)
  end

  test "defaults start_open to false and closeable to true" do
    c = ::Decor::Suite::Modals::Confirm.new(title: "T", message: "M")
    refute c.instance_variable_get(:@start_open)
    assert c.instance_variable_get(:@closeable)
  end

  test "accepts all variant options" do
    ::Decor::Components::Modals::Confirm::VARIANT_OPTIONS.each do |variant|
      assert_nothing_raised do
        ::Decor::Suite::Modals::Confirm.new(title: "T", message: "M", variant: variant)
      end
    end
  end

  test "does not emit its own Stimulus controller (composition-only wrapper)" do
    refute ::Decor::Suite::Modals::Confirm.stimulus_controller?
  end

  test "cancel button uses Suite::Modals::ModalCloseButton with outlined neutral chrome" do
    c = ::Decor::Suite::Modals::Confirm.new(title: "T", message: "M", cancel_label: "Cancel")
    btn = c.send(:cancel_button)

    assert_kind_of ::Decor::Suite::Modals::ModalCloseButton, btn
    assert_equal "Cancel", btn.instance_variable_get(:@label)
    assert_equal :sm, btn.instance_variable_get(:@size)
    assert_equal :outlined, btn.instance_variable_get(:@style)
    assert_equal :base, btn.instance_variable_get(:@color)
  end

  test "confirm button uses Suite::Button with primary fill by default" do
    c = ::Decor::Suite::Modals::Confirm.new(title: "T", message: "M", confirm_label: "OK")
    btn = c.send(:confirm_button)

    assert_kind_of ::Decor::Suite::Button, btn
    assert_equal "OK", btn.instance_variable_get(:@label)
    assert_equal :sm, btn.instance_variable_get(:@size)
    assert_equal :primary, btn.instance_variable_get(:@color)
    assert_equal :filled, btn.instance_variable_get(:@style)
  end

  test "destructive variant themes the confirm button :error" do
    c = ::Decor::Suite::Modals::Confirm.new(title: "Delete?", message: "M", variant: :destructive)
    btn = c.send(:confirm_button)
    assert_equal :error, btn.instance_variable_get(:@color)
  end

  test "confirm button mounts the confirm Stimulus controller and the click action" do
    c = ::Decor::Suite::Modals::Confirm.new(title: "T", message: "M")
    opts = c.send(:confirm_button_html_options)

    assert_equal "button", opts[:type].to_s
    assert_equal "decor--suite--modals--confirm", opts[:data][:controller]
    assert_equal "click->decor--suite--modals--confirm#confirm", opts[:data][:action]
  end

  test "confirm button carries the modal-id stimulus value" do
    c = ::Decor::Suite::Modals::Confirm.new(id: "confirm-x", title: "T", message: "M")
    opts = c.send(:confirm_button_html_options)

    assert_equal "confirm-x", opts[:data][:"decor--suite--modals--confirm-modal-id-value"]
  end

  test "confirm button carries the confirm-event stimulus value when set" do
    c = ::Decor::Suite::Modals::Confirm.new(title: "T", message: "M", confirm_event: "delete-order")
    opts = c.send(:confirm_button_html_options)

    assert_equal "delete-order", opts[:data][:"decor--suite--modals--confirm-confirm-event-value"]
  end

  test "confirm button omits the confirm-event stimulus value when not set" do
    c = ::Decor::Suite::Modals::Confirm.new(title: "T", message: "M")
    opts = c.send(:confirm_button_html_options)

    refute opts[:data].key?(:"decor--suite--modals--confirm-confirm-event-value")
  end

  test "renders a Suite Modal as the outer chrome" do
    html = render_component(::Decor::Suite::Modals::Confirm.new(title: "T", message: "M"))
    assert_includes html, "<dialog"
    assert_includes html, "decor--suite--modals--modal"
    assert_includes html, "decor-modal"
  end

  test "renders the title in the modal header" do
    html = render_component(::Decor::Suite::Modals::Confirm.new(title: "Delete order?", message: "M"))
    assert_includes html, "Delete order?"
  end

  test "renders the message in the modal body" do
    html = render_component(::Decor::Suite::Modals::Confirm.new(title: "T", message: "This can't be undone."))
    assert_includes html, "This can&#39;t be undone."
  end

  test "renders the footer Cancel + Confirm buttons" do
    html = render_component(::Decor::Suite::Modals::Confirm.new(title: "T", message: "M"))
    assert_includes html, "Cancel"
    assert_includes html, "Confirm"
  end

  test "honours custom labels" do
    html = render_component(
      ::Decor::Suite::Modals::Confirm.new(title: "Send?", message: "Now", confirm_label: "Send", cancel_label: "Wait")
    )
    assert_includes html, "Send"
    assert_includes html, "Wait"
  end

  test "destructive variant renders a danger-tinted header and confirm button" do
    html = render_component(
      ::Decor::Suite::Modals::Confirm.new(
        title: "Delete?",
        message: "M",
        variant: :destructive,
        confirm_label: "Delete"
      )
    )
    assert_includes html, "decor:bg-suite-danger-50"
    assert_includes html, "decor:text-suite-danger-700"
    assert_includes html, "decor:bg-suite-danger"
  end

  test "info variant renders the suite-primary accent bar" do
    html = render_component(::Decor::Suite::Modals::Confirm.new(title: "T", message: "M", variant: :info))
    assert_includes html, "decor:bg-suite-primary-500"
  end

  test "suppresses the modal close X (caller drives close via Cancel/Confirm)" do
    html = render_component(::Decor::Suite::Modals::Confirm.new(title: "T", message: "M"))
    refute_includes html, 'aria-label="Close"'
  end

  test "wires confirm controller + click action onto the confirm button" do
    html = render_component(::Decor::Suite::Modals::Confirm.new(title: "T", message: "M"))
    assert_includes html, "decor--suite--modals--confirm"
    assert_includes html, "click->decor--suite--modals--confirm#confirm"
  end

  test "emits the confirm-event stimulus value attribute in rendered HTML" do
    html = render_component(
      ::Decor::Suite::Modals::Confirm.new(title: "T", message: "M", confirm_event: "delete-order")
    )
    assert_includes html, %(data-decor--suite--modals--confirm-confirm-event-value="delete-order")
  end

  test "footer slot renders in suite-gray-25 surface (delegated to the inner Modal)" do
    html = render_component(::Decor::Suite::Modals::Confirm.new(title: "T", message: "M"))
    assert_includes html, "decor-modal__footer"
    assert_includes html, "decor:bg-suite-gray-25"
  end

  test "start_open flows through to the inner Modal" do
    html = render_component(::Decor::Suite::Modals::Confirm.new(title: "T", message: "M", start_open: true))
    assert_includes html, 'data-decor--suite--modals--modal-start-open-value="true"'
  end

  test "closeable flows through to the inner Modal" do
    html = render_component(::Decor::Suite::Modals::Confirm.new(title: "T", message: "M", closeable: false))
    assert_includes html, 'data-decor--suite--modals--modal-closeable-value="false"'
  end
end
