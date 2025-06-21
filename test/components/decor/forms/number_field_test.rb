require "test_helper"

class Decor::Forms::NumberFieldTest < ActiveSupport::TestCase
  test "renders successfully with valid attributes" do
    component = Decor::Forms::NumberField.new(name: "my_num", label: "Label", value: 123456)
    rendered = render_component(component)

    assert_includes rendered, "Label"
    assert_includes rendered, 'value="123456"'
    assert_includes rendered, 'name="my_num"'
    assert_includes rendered, 'type="number"'
  end

  test "renders without errors when given valid attributes" do
    assert_nothing_raised do
      component = Decor::Forms::NumberField.new(name: "my_num", label: "Label", value: 123456)
      render_component(component)
    end
  end
end
