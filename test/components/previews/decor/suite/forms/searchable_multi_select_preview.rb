# @label SearchableMultiSelect
class ::Decor::Suite::Forms::SearchableMultiSelectPreview < ::Lookbook::Preview
  # @group Examples
  # @label Default (XHR search)
  def default
    render ::Decor::Suite::Forms::SearchableMultiSelect.new(
      name: "user_ids[]",
      label: "Invited users",
      description: "Start typing to find users to invite",
      search_url: "/example/search"
    )
  end

  # @group Examples
  # @label Local choices
  def local_choices
    render ::Decor::Suite::Forms::SearchableMultiSelect.new(
      name: "colors[]",
      label: "Favourite colours",
      choices: [
        {id: "red", label: "Red", sublabel: "warm"},
        {id: "blue", label: "Blue", sublabel: "cool"},
        {id: "green", label: "Green", sublabel: "natural"},
        {id: "purple", label: "Purple", sublabel: "regal"}
      ]
    )
  end

  # @group Examples
  # @label Pre-populated chips
  def pre_populated
    render ::Decor::Suite::Forms::SearchableMultiSelect.new(
      name: "user_ids[]",
      label: "Invited users",
      search_url: "/example/search",
      selected_items: [
        {id: 1, label: "Ada Lovelace"},
        {id: 2, label: "Grace Hopper"}
      ]
    )
  end

  # @group Examples
  # @label Free-text tags
  def free_text
    render ::Decor::Suite::Forms::SearchableMultiSelect.new(
      name: "tags[]",
      label: "Tags",
      description: "Press Enter or comma to add a tag",
      allow_free_text: true,
      delimiter: ","
    )
  end

  # @group Playground
  # @param label text
  # @param description text
  # @param placeholder text
  # @param min_chars number
  # @param debounce_ms number
  # @param allow_free_text toggle
  # @param disabled toggle
  def playground(
    label: "Invited users",
    description: nil,
    placeholder: "Click to browse or type to search...",
    min_chars: 2,
    debounce_ms: 300,
    allow_free_text: false,
    disabled: false
  )
    render ::Decor::Suite::Forms::SearchableMultiSelect.new(
      name: "user_ids[]",
      label: label.presence,
      description: description.presence,
      placeholder: placeholder,
      min_chars: min_chars,
      debounce_ms: debounce_ms,
      allow_free_text: allow_free_text,
      disabled: disabled,
      search_url: "/example/search"
    )
  end
end
