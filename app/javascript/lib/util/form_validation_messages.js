// Consumers wire their own i18n via `window.decorI18n` — a flat
// `{ key: "message" }` dictionary. Missing keys fall back to the
// hardcoded English defaults below.

const RAILS_I18N_MESSAGE_REGEX = /%{([\s\S]+?)}/g;

const DEFAULTS = {
  invalid: "is invalid",
  blank: "can't be blank",
  does_not_match: "doesn't match",
  generic_server_error: "Sorry, an error occurred.",
  form_invalid_preamble: "Please review the following:",
};

export function localeMessage(key) {
  const fromConsumer =
    typeof window !== "undefined" && window.decorI18n
      ? window.decorI18n[key]
      : null;
  return fromConsumer || DEFAULTS[key] || key;
}

// Interpolates Rails-style `%{var}` placeholders in `message` using
// `variables`. Unknown placeholders collapse to the empty string, matching
// Rails' I18n fallback behaviour.
export function generateFormValidationMessage(message, variables = {}) {
  return message.replace(
    RAILS_I18N_MESSAGE_REGEX,
    (_m, key) => variables[key] || "",
  );
}
