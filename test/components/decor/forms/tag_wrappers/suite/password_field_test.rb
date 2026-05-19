require "test_helper"

class Decor::Forms::TagWrappers::Suite::PasswordFieldTest < ActiveSupport::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :password, :string

    def self.model_name
      ActiveModel::Name.new(self, nil, "TestModel")
    end
  end

  setup do
    @model = TestModel.new(password: "hunter2")
    @view = controller.view_context
    @view.instance_variable_set(:@test_model, @model)
  end

  def render_wrapper(options = {})
    wrapper = ::Decor::Forms::TagWrappers::Suite::PasswordField.new(
      "test_model",
      "password",
      @view,
      options
    )
    Nokogiri::HTML5.fragment(wrapper.render)
  end

  test "renders a Suite TextField with type=password" do
    input = render_wrapper.at_css("input")
    assert_not_nil input
    assert_equal "password", input["type"]
  end

  test "uses the Suite TextField component (not Daisy)" do
    fragment = render_wrapper
    assert_not_nil fragment.at_css(".decor--suite--forms--text-field")
  end

  test "uses the humanized method name as the default label" do
    fragment = render_wrapper
    assert_match(/Password/, fragment.text)
  end

  test "honours an explicit label option" do
    fragment = render_wrapper(label: "Choose a password")
    assert_match(/Choose a password/, fragment.text)
  end

  test "wires the input name to the object_name[method] convention" do
    input = render_wrapper.at_css("input")
    assert_equal "test_model[password]", input["name"]
  end

  test "forwards the object's attribute value to the input" do
    # Note: the underlying tag wrapper extends Tags::TextField (not
    # Tags::PasswordField), so the value is preserved. Callers wanting
    # strip-on-render behaviour should clear the attribute server-side.
    input = render_wrapper.at_css("input")
    assert_equal "hunter2", input["value"]
  end
end
