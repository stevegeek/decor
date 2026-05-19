require "test_helper"

class Decor::Forms::TagWrappers::Suite::EmailFieldTest < ActiveSupport::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :email, :string

    def self.model_name
      ActiveModel::Name.new(self, nil, "TestModel")
    end
  end

  setup do
    @model = TestModel.new(email: "alice@example.com")
    @view = controller.view_context
    @view.instance_variable_set(:@test_model, @model)
  end

  def render_wrapper(options = {})
    wrapper = ::Decor::Forms::TagWrappers::Suite::EmailField.new(
      "test_model",
      "email",
      @view,
      options
    )
    Nokogiri::HTML5.fragment(wrapper.render)
  end

  test "renders a Suite TextField with type=email" do
    fragment = render_wrapper
    input = fragment.at_css("input")
    assert_not_nil input
    assert_equal "email", input["type"]
  end

  test "uses the Suite TextField component (not Daisy)" do
    fragment = render_wrapper
    assert_not_nil fragment.at_css(".decor--suite--forms--text-field")
  end

  test "populates the input with the object's attribute value" do
    input = render_wrapper.at_css("input")
    assert_equal "alice@example.com", input["value"]
  end

  test "uses the humanized method name as the default label" do
    fragment = render_wrapper
    assert_match(/Email/, fragment.text)
  end

  test "honours an explicit label option" do
    fragment = render_wrapper(label: "Your email address")
    assert_match(/Your email address/, fragment.text)
  end

  test "wires the input name to the object_name[method] convention" do
    input = render_wrapper.at_css("input")
    assert_equal "test_model[email]", input["name"]
  end
end
