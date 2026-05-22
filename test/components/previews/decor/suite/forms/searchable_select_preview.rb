# @label SearchableSelect
class ::Decor::Suite::Forms::SearchableSelectPreview < ::Lookbook::Preview
  # @group Examples
  # @label Default (XHR search)
  def default
    render ::Decor::Suite::Forms::SearchableSelect.new(
      name: "user_id",
      label: "Assigned user",
      description: "Start typing to find a user",
      search_url: "/example/search"
    )
  end

  # @group Examples
  # @label Local choices
  def local_choices
    render ::Decor::Suite::Forms::SearchableSelect.new(
      name: "color",
      label: "Favourite colour",
      choices: [
        {id: "red", label: "Red", sublabel: "warm"},
        {id: "blue", label: "Blue", sublabel: "cool"},
        {id: "green", label: "Green", sublabel: "natural"},
        {id: "purple", label: "Purple", sublabel: "regal"}
      ]
    )
  end

  # @group Examples
  # @label Pre-selected value
  def pre_selected
    render ::Decor::Suite::Forms::SearchableSelect.new(
      name: "user_id",
      label: "Assigned user",
      search_url: "/example/search",
      selected_item: {id: 42, label: "Ada Lovelace"}
    )
  end

  # @group Examples
  # @label Without clear button
  def without_clear
    render ::Decor::Suite::Forms::SearchableSelect.new(
      name: "user_id",
      label: "Required field",
      allow_clear: false,
      selected_item: {id: 7, label: "Locked selection"}
    )
  end

  # @group Examples
  # @label Auto-submit on change
  def auto_submit
    render ::Decor::Suite::Forms::SearchableSelect.new(
      name: "filter_user_id",
      label: "Filter by user",
      search_url: "/example/search",
      auto_submit: true
    )
  end

  # @group Playground
  # @param label text
  # @param description text
  # @param placeholder text
  # @param min_chars number
  # @param debounce_ms number
  # @param allow_clear toggle
  # @param auto_submit toggle
  # @param disabled toggle
  def playground(
    label: "Assigned user",
    description: nil,
    placeholder: "Click to browse or type to search...",
    min_chars: 2,
    debounce_ms: 300,
    allow_clear: true,
    auto_submit: false,
    disabled: false
  )
    render ::Decor::Suite::Forms::SearchableSelect.new(
      name: "user_id",
      label: label.presence,
      description: description.presence,
      placeholder: placeholder,
      min_chars: min_chars,
      debounce_ms: debounce_ms,
      allow_clear: allow_clear,
      auto_submit: auto_submit,
      disabled: disabled,
      search_url: "/example/search"
    )
  end
end
