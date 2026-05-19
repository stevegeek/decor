// Pure validation helpers — no DOM dependency beyond a single document.getElementById
// in equalTo. Each helper takes a small attribute bag and returns either a
// boolean or one of "over" / "under" / "invalid" for range-shaped checks.
// Inspired by https://github.com/cferdinandi/bouncer.

const PATTERNS = {
  color: /^#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$/,
  date: /(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))/,
  email:
    /^([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22))*\x40([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d))*(\.\w{2,})+$/,
  month: /^(?:(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])))$/,
  number: /^(?:[-+]?[0-9]*[.,]?[0-9]+)$/,
  time: /^(?:(0[0-9]|1[0-9]|2[0-3])(:[0-5][0-9]))$/,
  url: /^(?:(?:https?|HTTPS?|ftp|FTP):\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-zA-Z¡-￿0-9]-*)*[a-zA-Z¡-￿0-9]+)(?:\.(?:[a-zA-Z¡-￿0-9]-*)*[a-zA-Z¡-￿0-9]+)*(?:\.(?:[a-zA-Z¡-￿]{2,}))\.?)(?::\d{2,5})?(?:[/?#]\S*)?$/,
};

export function missingValue(attrs) {
  return attrs.required && !attrs.value.length;
}

export function missingCheckboxValue(attrs) {
  return attrs.required && !attrs.checked;
}

export function missingRadioValue(attrs) {
  // Any is required && none are checked
  return (
    attrs.some((attr) => attr.required) && attrs.every((attr) => !attr.checked)
  );
}

export function patternMismatch(attrs) {
  const { pattern, type, value } = attrs;

  if (!value) {
    return false;
  }

  // Dynamic regex construction here is gated by trusted input — pattern comes
  // from a server-emitted HTML attribute. If untrusted callers ever drive it,
  // wrap with safe-regex or move to a precompiled allowlist.
  const chosenPattern = pattern
    ? new RegExp("^(?:" + pattern + ")$")
    : PATTERNS[type];
  if (!chosenPattern) {
    return false;
  }

  return !value.match(chosenPattern);
}

export function outOfRange(attrs) {
  const { max, min, gt, lt, value } = attrs;

  if (!value) {
    return false;
  }

  if (
    (gt !== null || lt !== null || min !== null || max !== null) &&
    !value.match(PATTERNS["number"])
  ) {
    return "invalid";
  }

  const num = parseFloat(value);

  if (gt !== null && num <= parseFloat(gt)) {
    return "under";
  }
  if (lt !== null && num >= parseFloat(lt)) {
    return "over";
  }
  if (gt === null && min !== null && num < parseFloat(min)) {
    return "under";
  }
  if (lt === null && max !== null && num > parseFloat(max)) {
    return "over";
  }
  return false;
}

export function wrongLength(attrs) {
  const { max, min, value } = attrs;

  if (!value) {
    return false;
  }

  const { length } = value;
  if (max !== null && length > parseFloat(max)) {
    return "over";
  }
  if (min !== null && length < parseFloat(min)) {
    return "under";
  }
  return false;
}

export function equalTo(attrs) {
  const { value, equalToId } = attrs;

  if (!equalToId || !value) {
    return false;
  }

  let targetElement = document.getElementById(equalToId);
  if (!targetElement) {
    return false;
  }

  // If the target is a wrapper element (not an input), find the input within it
  if (
    !(targetElement instanceof HTMLInputElement) &&
    !(targetElement instanceof HTMLTextAreaElement)
  ) {
    targetElement = targetElement.querySelector("input, textarea");
    if (!targetElement) {
      return false;
    }
  }

  return value !== targetElement.value;
}

export function typeMismatch(attrs) {
  const { type, value } = attrs;

  if (!value) {
    return false;
  }

  switch (type) {
    case "number": {
      const parsed = parseFloat(value);
      return Number.isNaN(parsed);
    }
    case "boolean": {
      const normalised = value.toLowerCase().trim();
      return normalised !== "true" && normalised !== "false";
    }
    default:
      return false;
  }
}
