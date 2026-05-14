if defined?(Lookbook)
  Rails.application.config.lookbook.preview_paths = [
    Rails.root.join("..", "components", "previews").expand_path.to_s
  ]
  Rails.application.config.lookbook.page_paths = [
    Rails.root.join("..", "components", "docs").expand_path.to_s
  ]
end
