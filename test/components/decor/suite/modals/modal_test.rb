# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Modals::ModalTest < ActiveSupport::TestCase
  test "renders a <dialog> root with the cf-modal class" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T"))
    assert_includes html, "<dialog"
    assert_includes html, "cf-modal"
  end

  test "wires the suite modal stimulus controller" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T"))
    assert_includes html, 'data-controller="decor--suite--modals--modal"'
  end

  test "listens for the window-scoped open and close events" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T"))
    assert_includes html, "decor--suite--modals--modal:open@window->decor--suite--modals--modal#handleOpenEvent"
    assert_includes html, "decor--suite--modals--modal:close@window->decor--suite--modals--modal#handleCloseEvent"
  end

  test "applies suite-card radius and white surface" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T"))
    assert_includes html, "decor:rounded-suite-card"
    assert_includes html, "decor:bg-white"
  end

  test "default size renders 420px width" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T"))
    assert_includes html, "decor:w-[420px]"
  end

  test "size :wide renders 560px width" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", size: :wide))
    assert_includes html, "decor:w-[560px]"
  end

  test "size :extra_wide renders 680px width" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", size: :extra_wide))
    assert_includes html, "decor:w-[680px]"
  end

  test "size :huge renders 1024px width" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", size: :huge))
    assert_includes html, "decor:w-[1024px]"
  end

  test "size :narrow renders 360px width" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", size: :narrow))
    assert_includes html, "decor:w-[360px]"
  end

  test "renders title with suite-section-title typography" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "Modal title"))
    assert_includes html, "Modal title"
    assert_includes html, "decor:suite-section-title"
  end

  test "renders description with suite-description typography" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", description: "subtitle"))
    assert_includes html, "subtitle"
    assert_includes html, "decor:suite-description"
  end

  test "header uses hairline-border separator on non-destructive variants" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T"))
    assert_includes html, "decor:border-suite-hairline"
  end

  test "destructive variant uses suite-danger header chrome" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "Delete", variant: :destructive))
    assert_includes html, "decor:bg-suite-danger-50"
    assert_includes html, "decor:border-suite-danger-100"
    assert_includes html, "decor:text-suite-danger-700"
  end

  test "destructive variant does not render an accent bar" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "Delete", variant: :destructive))
    refute_includes html, "decor:absolute decor:left-0 decor:top-0 decor:bottom-0 decor:w-[3px]"
  end

  test "info variant renders accent bar in suite-primary" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "Heads", variant: :info))
    assert_includes html, "decor:bg-suite-primary-500"
  end

  test "success variant renders accent bar in suite-success" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "Ok", variant: :success))
    assert_includes html, "decor:bg-suite-success-500"
  end

  test "warning variant renders accent bar in suite-warning" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "W", variant: :warning))
    assert_includes html, "decor:bg-suite-warning-500"
  end

  test "danger variant renders accent bar in suite-danger" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "D", variant: :danger))
    assert_includes html, "decor:bg-suite-danger-500"
  end

  test "neutral variant renders no accent bar" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "N", variant: :neutral))
    refute_includes html, "decor:bg-suite-primary-500"
    refute_includes html, "decor:bg-suite-success-500"
  end

  test "closeable: true emits closedby=any on the dialog" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", closeable: true))
    assert_includes html, 'closedby="any"'
  end

  test "closeable: false omits closedby" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", closeable: false))
    refute_includes html, "closedby"
  end

  test "renders a close X button when closeable and show_close_button" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T"))
    assert_includes html, 'aria-label="Close"'
    assert_includes html, "click->decor--suite--modals--modal#close"
    assert_includes html, "decor:rounded-suite-control"
  end

  test "suppresses close X when show_close_button is false" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", show_close_button: false))
    refute_includes html, 'aria-label="Close"'
  end

  test "suppresses close X when closeable is false" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", closeable: false))
    refute_includes html, 'aria-label="Close"'
  end

  test "renders body content from a block" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T")) { "the-body-content".html_safe }
    assert_includes html, "the-body-content"
    assert_includes html, "cf-modal__body"
  end

  test "renders initial_content as raw HTML when caller marks it safe" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", initial_content: "<p>baked</p>".html_safe))
    assert_includes html, "<p>baked</p>"
  end

  test "escapes initial_content when caller passes a plain String" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", initial_content: "<script>alert(1)</script>"))
    refute_includes html, "<script>alert(1)</script>"
    assert_includes html, "&lt;script&gt;"
  end

  test "content_href reserves min-height in the body" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", content_href: "/x"))
    assert_includes html, "decor:min-h-[120px]"
  end

  test "content_href stimulus value flows through" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", content_href: "/rows/42"))
    assert_includes html, 'data-decor--suite--modals--modal-content-href-value="/rows/42"'
  end

  test "start_open stimulus value flows through" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", start_open: true))
    assert_includes html, 'data-decor--suite--modals--modal-start-open-value="true"'
  end

  test "closeable stimulus value flows through" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", closeable: false))
    assert_includes html, 'data-decor--suite--modals--modal-closeable-value="false"'
  end

  test "footer slot renders in suite-gray-25 surface with hairline top border" do
    modal = ::Decor::Suite::Modals::Modal.new(id: "m1", title: "T")
    modal.with_footer { "<button>OK</button>".html_safe }
    html = render_component(modal) { "body" }
    assert_includes html, "cf-modal__footer"
    assert_includes html, "decor:bg-suite-gray-25"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "<button>OK</button>"
  end

  test "footer not rendered when no footer block provided" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T")) { "body" }
    refute_includes html, "cf-modal__footer"
  end

  test "title gets aria-labelledby pointing at the dialog title id" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T"))
    assert_includes html, 'aria-labelledby="m1-title"'
    assert_includes html, 'id="m1-title"'
  end

  test "body gets aria-describedby pointing at the dialog body id" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T")) { "body" }
    assert_includes html, 'aria-describedby="m1-body"'
    assert_includes html, 'id="m1-body"'
  end

  test "does not emit any daisyUI semantic color tokens (info/success/warning/error)" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", variant: :info)) { "x" }
    refute_includes html, "decor:bg-info"
    refute_includes html, "decor:text-info"
    refute_includes html, "decor:border-info"
  end

  test "inherits from the Components::Modals::Modal abstract base" do
    assert ::Decor::Suite::Modals::Modal.new(id: "m1").is_a?(::Decor::Components::Modals::Modal)
  end

  test "default variant icon is omitted (neutral has no auto-icon)" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "Neutral"))
    refute_includes html, "tabler-information-circle"
    refute_includes html, "tabler-check-circle"
  end

  test "danger variant auto-selects exclamation-circle icon" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "D", variant: :danger))
    assert_includes html, "exclamation-circle"
  end

  test "explicit icon string overrides the variant default" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", variant: :danger, icon: "x-mark"))
    assert_includes html, "x-mark"
  end

  test "icon: false suppresses the icon" do
    html = render_component(::Decor::Suite::Modals::Modal.new(id: "m1", title: "T", variant: :danger, icon: false))
    refute_includes html, "exclamation-circle"
  end
end
