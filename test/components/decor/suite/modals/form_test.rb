# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Modals::FormTest < ActiveSupport::TestCase
  test "inherits from Components::Modals::Form" do
    assert ::Decor::Suite::Modals::Form.new(title: "X").is_a?(::Decor::Components::Modals::Form)
  end

  test "exposes form_id derived from the Vident id by default" do
    form = ::Decor::Suite::Modals::Form.new(title: "Edit item")
    assert_equal "#{form.id}-form", form.form_id
  end

  test "honours an explicit form_id when provided" do
    form = ::Decor::Suite::Modals::Form.new(title: "Edit item", form_id: "my-form")
    assert_equal "my-form", form.form_id
  end

  test "form_id is stable across calls" do
    form = ::Decor::Suite::Modals::Form.new(title: "Edit item")
    assert_equal form.form_id, form.form_id
  end

  test "defaults submit_label to 'Save' and cancel_label to 'Cancel'" do
    form = ::Decor::Suite::Modals::Form.new(title: "Edit item")
    assert_equal "Save", form.instance_variable_get(:@submit_label)
    assert_equal "Cancel", form.instance_variable_get(:@cancel_label)
  end

  test "defaults variant to :neutral and size to :default" do
    form = ::Decor::Suite::Modals::Form.new(title: "Edit item")
    assert_equal :neutral, form.instance_variable_get(:@variant)
    assert_equal :default, form.instance_variable_get(:@size)
  end

  test "defaults submit_color to :primary" do
    form = ::Decor::Suite::Modals::Form.new(title: "Edit item")
    assert_equal :primary, form.instance_variable_get(:@submit_color)
  end

  test "defaults start_open to false" do
    form = ::Decor::Suite::Modals::Form.new(title: "Edit item")
    refute form.instance_variable_get(:@start_open)
  end

  test "accepts all variant options" do
    ::Decor::Components::Modals::Form::VARIANT_OPTIONS.each do |variant|
      assert_nothing_raised do
        ::Decor::Suite::Modals::Form.new(title: "X", variant: variant)
      end
    end
  end

  test "accepts all size options" do
    ::Decor::Components::Modals::Form::SIZE_OPTIONS.each do |size|
      assert_nothing_raised do
        ::Decor::Suite::Modals::Form.new(title: "X", size: size)
      end
    end
  end

  test "accepts all submit_color options" do
    ::Decor::Components::Modals::Form::SUBMIT_COLOR_OPTIONS.each do |color|
      assert_nothing_raised do
        ::Decor::Suite::Modals::Form.new(title: "X", submit_color: color)
      end
    end
  end

  test "title is required" do
    assert_raises(ArgumentError) do
      ::Decor::Suite::Modals::Form.new
    end
  end

  test "cancel button uses Suite::Modals::ModalCloseButton with outlined neutral chrome" do
    form = ::Decor::Suite::Modals::Form.new(title: "Edit", cancel_label: "Cancel")
    btn = form.send(:cancel_button)

    assert_kind_of ::Decor::Suite::Modals::ModalCloseButton, btn
    assert_equal "Cancel", btn.instance_variable_get(:@label)
    assert_equal :sm, btn.instance_variable_get(:@size)
    assert_equal :outlined, btn.instance_variable_get(:@style)
    assert_equal :base, btn.instance_variable_get(:@color)
  end

  test "submit button uses Suite::Button with primary fill and targets the form via HTML5 form attribute" do
    form = ::Decor::Suite::Modals::Form.new(title: "Edit", submit_label: "Save")
    btn = form.send(:submit_button)

    assert_kind_of ::Decor::Suite::Button, btn
    assert_equal "Save", btn.instance_variable_get(:@label)
    assert_equal :sm, btn.instance_variable_get(:@size)
    assert_equal :primary, btn.instance_variable_get(:@color)
    assert_equal :filled, btn.instance_variable_get(:@style)

    html_options = btn.instance_variable_get(:@html_options)
    assert_equal "submit", html_options[:type]
    assert_equal form.form_id, html_options[:form]
  end

  test "submit button colour follows the submit_color prop (error)" do
    form = ::Decor::Suite::Modals::Form.new(title: "Delete", submit_color: :error)
    btn = form.send(:submit_button)
    assert_equal :error, btn.instance_variable_get(:@color)
  end

  test "submit button colour follows the submit_color prop (warning)" do
    form = ::Decor::Suite::Modals::Form.new(title: "Restore", submit_color: :warning)
    btn = form.send(:submit_button)
    assert_equal :warning, btn.instance_variable_get(:@color)
  end

  test "carries content_href + initial_content + start_open through for the inner Modal" do
    safe = "<p>preloaded</p>".html_safe
    form = ::Decor::Suite::Modals::Form.new(
      title: "Edit",
      content_href: "/edit",
      initial_content: safe,
      start_open: true
    )

    assert_equal "/edit", form.instance_variable_get(:@content_href)
    assert_equal safe, form.instance_variable_get(:@initial_content)
    assert form.instance_variable_get(:@start_open)
  end

  test "does not emit its own Stimulus controller (composition-only wrapper)" do
    refute ::Decor::Suite::Modals::Form.stimulus_controller?
  end

  test "renders a Suite Modal as the outer chrome" do
    html = render_component(::Decor::Suite::Modals::Form.new(title: "Edit item"))
    assert_includes html, "<dialog"
    assert_includes html, "decor--suite--modals--modal"
  end

  test "renders the title in the modal header" do
    html = render_component(::Decor::Suite::Modals::Form.new(title: "Edit catalog"))
    assert_includes html, "Edit catalog"
  end

  test "renders the description when provided" do
    html = render_component(::Decor::Suite::Modals::Form.new(title: "Edit", description: "Update fields below."))
    assert_includes html, "Update fields below."
  end

  test "renders the footer Cancel + Submit buttons" do
    html = render_component(::Decor::Suite::Modals::Form.new(title: "Edit"))
    assert_includes html, "Cancel"
    assert_includes html, "Save"
  end

  test "submit button carries the HTML5 form attribute pointing at form_id" do
    form = ::Decor::Suite::Modals::Form.new(title: "Edit")
    html = render_component(form)
    assert_includes html, %(form="#{form.form_id}")
    assert_includes html, %(type="submit")
  end

  test "honours custom labels" do
    html = render_component(
      ::Decor::Suite::Modals::Form.new(title: "Delete", submit_label: "Delete", cancel_label: "Keep")
    )
    assert_includes html, "Delete"
    assert_includes html, "Keep"
  end

  test "destructive variant + submit_color: :error renders a danger-tinted submit button" do
    html = render_component(
      ::Decor::Suite::Modals::Form.new(
        title: "Delete account",
        variant: :destructive,
        submit_label: "Delete",
        submit_color: :error
      )
    )
    assert_includes html, "decor:bg-suite-danger"
  end

  test "renders the destructive-action slot anchor for client-side injection" do
    html = render_component(::Decor::Suite::Modals::Form.new(title: "Edit"))
    assert_includes html, "modal-destructive-slot"
  end

  test "yields a block as the form body" do
    html = render_component(::Decor::Suite::Modals::Form.new(title: "Edit")) do
      "<form id=\"my-form\">field</form>".html_safe
    end
    assert_includes html, %(id="my-form")
    assert_includes html, "field"
  end
end
