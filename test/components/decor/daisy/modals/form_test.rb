# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::Modals::FormTest < ActiveSupport::TestCase
  test "inherits from Components::Modals::Form" do
    assert ::Decor::Daisy::Modals::Form.new(title: "X").is_a?(::Decor::Components::Modals::Form)
  end

  test "does not emit its own stimulus controller" do
    refute ::Decor::Daisy::Modals::Form.stimulus_controller?
  end

  test "exposes form_id derived from the Vident id by default" do
    form = ::Decor::Daisy::Modals::Form.new(title: "Edit item")
    assert_equal "#{form.id}-form", form.form_id
  end

  test "honours an explicit form_id when provided" do
    form = ::Decor::Daisy::Modals::Form.new(title: "Edit item", form_id: "my-form")
    assert_equal "my-form", form.form_id
  end

  test "renders a Daisy Modal as the outer chrome" do
    html = render_component(::Decor::Daisy::Modals::Form.new(title: "Edit"))
    assert_includes html, "<dialog"
    assert_includes html, "decor--daisy--modals--modal"
    assert_includes html, "decor:d-modal"
  end

  test "renders Cancel and Save buttons in the footer area" do
    html = render_component(::Decor::Daisy::Modals::Form.new(title: "Edit"))
    assert_includes html, "Cancel"
    assert_includes html, "Save"
  end

  test "cancel button uses Daisy ModalCloseButton with outlined chrome at sm size" do
    html = render_component(::Decor::Daisy::Modals::Form.new(title: "Edit"))
    assert_includes html, "decor--daisy--modals--modal-close-button"
    assert_includes html, "decor:d-btn-outline"
    assert_includes html, "decor:d-btn-sm"
  end

  test "submit button targets the form via the HTML5 form attribute pointing at form_id" do
    form = ::Decor::Daisy::Modals::Form.new(title: "Edit")
    html = render_component(form)
    assert_includes html, %(form="#{form.form_id}")
    assert_includes html, %(type="submit")
  end

  test "submit button is a Daisy Button with d-btn-primary by default" do
    html = render_component(::Decor::Daisy::Modals::Form.new(title: "Edit"))
    assert_includes html, "decor--daisy--button"
    assert_includes html, "decor:d-btn-primary"
  end

  test "submit button colour follows submit_color: :error" do
    html = render_component(::Decor::Daisy::Modals::Form.new(title: "Delete", submit_color: :error))
    assert_includes html, "decor:d-btn-error"
  end

  test "submit button colour follows submit_color: :warning" do
    html = render_component(::Decor::Daisy::Modals::Form.new(title: "Restore", submit_color: :warning))
    assert_includes html, "decor:d-btn-warning"
  end

  test "honours custom labels" do
    html = render_component(
      ::Decor::Daisy::Modals::Form.new(title: "Delete", submit_label: "Delete", cancel_label: "Keep")
    )
    assert_includes html, "Delete"
    assert_includes html, "Keep"
  end

  test "renders the footer row outside the dialog (Daisy modal has no footer slot)" do
    html = render_component(::Decor::Daisy::Modals::Form.new(title: "Edit"))
    assert_includes html, "decor:flex"
    assert_includes html, "decor:justify-end"
    assert_includes html, "decor:gap-2"
  end

  test "start_open flows through to the inner Modal as show_initial" do
    html = render_component(::Decor::Daisy::Modals::Form.new(title: "Edit", start_open: true))
    assert_includes html, 'data-decor--daisy--modals--modal-show-initial-value="true"'
  end

  test "accepts a body block without raising" do
    assert_nothing_raised do
      render_component(::Decor::Daisy::Modals::Form.new(title: "Edit")) do
        "<input/>".html_safe
      end
    end
  end

  test "renders body block content inside the dialog body container" do
    form = ::Decor::Daisy::Modals::Form.new(title: "Edit")
    fragment = render_fragment(form) { "form-body-marker".html_safe }

    body = fragment.at_css("div[data-decor--daisy--modals--modal-target='modal']")
    assert_not_nil body
    assert_includes body.inner_html, "form-body-marker"
  end
end
