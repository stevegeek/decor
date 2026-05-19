import { Controller } from "@hotwired/stimulus"
// Side-effect import: registers <calendar-date>, <calendar-range>,
// <calendar-multi>, and <calendar-month> custom elements. Without this
// the cally tags render as inert unknown elements with no UI.
import "cally"

// Connects to data-controller="decor--daisy--forms--date-calendar"
//
// Targets:
//   calendar       - the cally <calendar-date>/<calendar-month>/etc element
//   hiddenInput    - the form value carrier (always present)
//   popoverTrigger - read-only text input that opens the popover (popover mode only)
//   popoverPanel   - the [popover] div containing the calendar (popover mode only)
//
// In popover mode the controller anchors the popover panel below the trigger
// via inline top/left written before showPopover(), copies the formatted
// value into the trigger input on change, and dismisses the popover via
// hidePopover() so the user can immediately see what they picked.
export default class extends Controller {
  static targets = ["calendar", "hiddenInput", "popoverTrigger", "popoverPanel"]
  static values = {
    calendarType: { type: String, default: null },
    locale: { type: String, default: null },
    months: Number,
    disabledDates: Array,
    disabledDaysOfWeek: Array,
    enabledDates: Array,
    enabledDaysOfWeek: Array
  }

  connect() {
    this.setupCalendar()
  }

  setupCalendar() {
    if (!this.hasCalendarTarget) return

    const calendar = this.calendarTarget
    
    // Set up date filtering if configured
    if (this.disabledDatesValue.length > 0 || this.disabledDaysOfWeekValue.length > 0) {
      calendar.isDateDisallowed = this.isDateDisallowed.bind(this)
    }
    
    // Listen for calendar change events
    calendar.addEventListener('change', this.handleChange.bind(this))
    
    // For range calendars, also listen for range events
    if (this.calendarTypeValue === 'range') {
      calendar.addEventListener('rangestart', this.handleRangeStart.bind(this))
      calendar.addEventListener('rangeend', this.handleRangeEnd.bind(this))
    }
    
    // For multi calendars, handle multiple selection
    if (this.calendarTypeValue === 'multi') {
      calendar.addEventListener('focusday', this.handleFocusDay.bind(this))
    }
  }

  handleChange(event) {
    if (!this.hasHiddenInputTarget) return

    const calendar = event.target
    const value = calendar.value

    // Update the hidden input with the selected value(s)
    this.hiddenInputTarget.value = value || ''

    // Dispatch a custom change event for form integration
    this.hiddenInputTarget.dispatchEvent(new Event('change', { bubbles: true }))

    // Popover mode: mirror the picked value into the trigger input and
    // dismiss the popover. Skipped for :range / :multi where the user may
    // still be making more picks — dismiss only on the second range click
    // (rangeend) for ranges, never for multi.
    if (this.hasPopoverTriggerTarget) {
      this.popoverTriggerTarget.value = value || ''
      if (this.calendarTypeValue !== 'range' && this.calendarTypeValue !== 'multi') {
        this._closePopover()
      }
    }

    // Call any additional change handlers
    if (this.onChangeCallback) {
      this.onChangeCallback(value)
    }
  }

  openPopover() {
    if (!this.hasPopoverPanelTarget || !this.hasPopoverTriggerTarget) return
    const panel = this.popoverPanelTarget
    const trigger = this.popoverTriggerTarget

    // Anchor the popover below the trigger. Native popovers open into the
    // top-layer (above everything) but UA-position to the viewport — we have
    // to write top/left inline so the panel hugs the trigger.
    const rect = trigger.getBoundingClientRect()
    panel.style.position = 'fixed'
    panel.style.top = `${rect.bottom + 4}px`
    panel.style.left = `${rect.left}px`

    panel.showPopover()
    trigger.setAttribute('aria-expanded', 'true')

    // Sync aria-expanded back to false on dismiss (Escape / click-outside /
    // explicit hidePopover). One-shot via the native `toggle` event.
    panel.addEventListener('toggle', (e) => {
      if (e.newState === 'closed') {
        trigger.setAttribute('aria-expanded', 'false')
      }
    }, { once: true })
  }

  _closePopover() {
    if (this.hasPopoverPanelTarget && this.popoverPanelTarget.matches(':popover-open')) {
      this.popoverPanelTarget.hidePopover()
    }
  }

  handleRangeStart(event) {
    // Handle range selection start
    console.debug('Range selection started:', event.detail)
  }

  handleRangeEnd(event) {
    // Handle range selection completion
    console.debug('Range selection completed:', event.detail)
    // Popover mode: range now has both endpoints — dismiss the popover.
    if (this.hasPopoverPanelTarget) this._closePopover()
  }

  handleFocusDay(event) {
    // Handle focus changes in multi-select calendar
    console.debug('Focus day changed:', event.detail)
  }

  isDateDisallowed(date) {
    const dateObj = new Date(date)
    const dateString = dateObj.toISOString().split('T')[0] // YYYY-MM-DD format
    const dayOfWeek = dateObj.getDay()

    // Check if date is specifically disabled
    if (this.disabledDatesValue.length > 0) {
      if (this.disabledDatesValue.includes(dateString)) {
        return true
      }
    }

    // Check if day of week is disabled
    if (this.disabledDaysOfWeekValue.length > 0) {
      if (this.disabledDaysOfWeekValue.includes(dayOfWeek)) {
        return true
      }
    }

    // Check if only specific dates are enabled (if configured)
    if (this.enabledDatesValue.length > 0) {
      if (!this.enabledDatesValue.includes(dateString)) {
        return true
      }
    }

    // Check if only specific days of week are enabled
    if (this.enabledDaysOfWeekValue.length > 0 && this.enabledDaysOfWeekValue.length < 7) {
      if (!this.enabledDaysOfWeekValue.includes(dayOfWeek)) {
        return true
      }
    }

    return false
  }

  // Allow external code to set change callbacks
  setOnChangeCallback(callback) {
    this.onChangeCallback = callback
  }

  // Programmatically set the calendar value
  setValue(value) {
    if (!this.hasCalendarTarget) return

    this.calendarTarget.value = value
    if (this.hasHiddenInputTarget) {
      this.hiddenInputTarget.value = value || ''
    }
  }

  // Get the current calendar value
  getValue() {
    if (!this.hasCalendarTarget) return null
    return this.calendarTarget.value
  }

  // Clear the calendar selection
  clear() {
    this.setValue('')
  }

  // Enable/disable the calendar
  setDisabled(disabled) {
    if (!this.hasCalendarTarget) return

    if (disabled) {
      this.calendarTarget.setAttribute('disabled', '')
    } else {
      this.calendarTarget.removeAttribute('disabled')
    }
  }
}