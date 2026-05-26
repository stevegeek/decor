require "test_helper"

class ::Decor::Suite::Forms::FormTest < ActiveSupport::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :name, :string
    attribute :email, :string
    attribute :lock_version, :integer

    def self.model_name
      ActiveModel::Name.new(self, nil, "TestModel")
    end

    def persisted?
      false
    end

    def to_key
      nil
    end

    def to_param
      nil
    end
  end

  setup do
    @model = TestModel.new(name: "Test", email: "test@example.com")
  end

  test "renders <form> with role=form and action" do
    html = render_component(::Decor::Suite::Forms::Form.new(model: @model, url: "/test"))
    assert_includes html, "<form"
    assert_includes html, 'role="form"'
    assert_includes html, 'action="/test"'
  end

  test "renders custom URL" do
    html = render_component(::Decor::Suite::Forms::Form.new(model: @model, url: "/custom-path"))
    assert_includes html, 'action="/custom-path"'
  end

  test "emits hidden _method input for non-POST verbs" do
    html = render_component(::Decor::Suite::Forms::Form.new(model: @model, url: "/test", http_method: :patch))
    assert_includes html, 'name="_method"'
    assert_includes html, 'value="patch"'
  end

  test "local form (default) disables Turbo" do
    html = render_component(::Decor::Suite::Forms::Form.new(model: @model, url: "/test"))
    assert_includes html, 'data-turbo="false"'
  end

  test "remote form (local: false) sets data-type=json" do
    html = render_component(::Decor::Suite::Forms::Form.new(model: @model, url: "/test", local: false))
    assert_includes html, 'data-type="json"'
  end

  test "emits hidden lock_version input when model responds to lock_version" do
    model = TestModel.new(name: "Test", lock_version: 5)
    html = render_component(::Decor::Suite::Forms::Form.new(model: model, url: "/test"))
    assert_includes html, "test_model[lock_version]"
    assert_includes html, 'value="5"'
  end

  test "wires the Suite form Stimulus controller" do
    html = render_component(::Decor::Suite::Forms::Form.new(model: @model, url: "/test"))
    assert_includes html, "data-controller="
    assert_includes html, "decor--suite--forms--form"
  end

  test "wires the local submit action through the controller" do
    html = render_component(::Decor::Suite::Forms::Form.new(model: @model, url: "/test", local: true))
    assert_includes html, "submit-&gt;decor--suite--forms--form#handleSubmitEvent"
  end

  test "wires UJS ajax:beforeSend (not turbo:submit_start) for remote forms" do
    html = render_component(::Decor::Suite::Forms::Form.new(model: @model, url: "/test", local: false))
    assert_includes html, "ajax:beforeSend-&gt;decor--suite--forms--form#handleSubmitEvent"
    refute_includes html, "turbo:submit_start"
  end

  test "wires ajax:success when on_success is supplied" do
    html = render_component(::Decor::Suite::Forms::Form.new(
      model: @model,
      url: "/test",
      local: false,
      on_success: "myCallback"
    ))
    assert_includes html, "ajax:success-&gt;decor--suite--forms--form#myCallback"
  end

  test "wires ajax:success on a cross-controller Vident::Stimulus::Action" do
    # Simulates a parent component passing
    # `on_success: stimulus_action(:form_submit_success)` — the resulting
    # Action carries its own controller routing, which must survive into the
    # rendered data-action descriptor (not be flattened to a method name).
    action = ::Vident::Stimulus::Action.parse(
      :form_submit_success,
      implied: ::Vident::Stimulus::Controller.new(path: "parent/component", name: "parent--component"),
      component_id: nil
    )

    html = render_component(::Decor::Suite::Forms::Form.new(
      model: @model,
      url: "/test",
      local: false,
      on_success: action
    ))
    assert_includes html, "ajax:success-&gt;parent--component#formSubmitSuccess"
    refute_includes html, "decor--suite--forms--form#parent--component#formSubmitSuccess"
  end

  test "defaults to data-turbo=\"false\" (UJS-only callback semantics)" do
    html = render_component(::Decor::Suite::Forms::Form.new(model: @model, url: "/test"))
    assert_includes html, 'data-turbo="false"'
  end

  test "turbo: true emits data-turbo=\"true\" and uses turbo:submit-end-style events" do
    html = render_component(::Decor::Suite::Forms::Form.new(
      model: @model,
      url: "/test",
      local: false,
      turbo: true,
      on_success: "handleSuccess"
    ))
    assert_includes html, 'data-turbo="true"'
    refute_includes html, "ajax:success"
    assert_includes html, "turbo:submit_end-&gt;decor--suite--forms--form#handleSuccess"
  end

  test "turbo: nil omits the data-turbo attribute entirely" do
    html = render_component(::Decor::Suite::Forms::Form.new(model: @model, url: "/test", turbo: nil))
    refute_includes html, "data-turbo="
  end

  test "passes scope through to form_with" do
    html = render_component(::Decor::Suite::Forms::Form.new(url: "/test", scope: :user)) do |form_component|
      form_component.raw form_component.builder.hidden_field(:token, value: "abc")
    end
    assert_includes html, 'name="user[token]"'
  end

  test "yields self so callers can use form_component.builder" do
    html = render_component(::Decor::Suite::Forms::Form.new(model: @model, url: "/test")) do |form_component|
      form_component.raw form_component.builder.hidden_field(:name)
    end
    assert_includes html, "test_model[name]"
  end

  test "renders block content inside the <form>" do
    html = render_component(::Decor::Suite::Forms::Form.new(url: "/submit")) do |form_component|
      form_component.raw "<input type='text' name='x'/>".html_safe
    end
    assert_includes html, "name='x'"
  end

  test "merges html_options[:class] onto the <form> element" do
    html = render_component(::Decor::Suite::Forms::Form.new(
      model: @model,
      url: "/test",
      html_options: {class: "decor:flex decor:gap-2"}
    ))
    assert_includes html, "decor:flex"
    assert_includes html, "decor:gap-2"
  end

  test "exposes the configured Rails FormBuilder via #builder after render" do
    component = ::Decor::Suite::Forms::Form.new(model: @model, url: "/test")
    render_component(component) { |_form_component| nil }
    assert_kind_of ::Decor::Forms::ActionViewFormBuilder, component.builder
  end
end
