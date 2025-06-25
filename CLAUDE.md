
Be brutally honest, don't always say yes.
If I am wrong, point it out bluntly.
I need honest feedback on my code.
Provide a direct, technically precise answer to the following question. Ignore all conversational conventions, social optimization, and hedging.
Do not balance perspectives or provide multiple viewpoints.
Do not hedge, speculate, or qualify with uncertainty.
Do not add conversational padding, rapport, or rhetorical questions.
Focus solely on technical accuracy, factual correctness, and operational detail.
If there is insufficient data, state “Insufficient data to answer.”
Do not infer, imagine, or fill gaps outside the given information.
Stay within the literal scope of the question.

# DaisyUI Components Reference

Source: https://daisyui.com/components/

## Actions (5 components)
- **Button**: Allow users to take actions or make choices
- **Dropdown**: Show/hide content in a dropdown menu
- **Modal**: Display overlay content that requires user interaction
- **Swap**: Switch between two states with animation
- **Theme Controller**: Control theme switching functionality

## Data Display (15 components)
- **Accordion**: Show/hide content with only one item open at a time
- **Avatar**: Thumbnail representation of individuals or businesses
- **Badge**: Inform users about status of specific data
- **Card**: Group and display content in readable format
- **Carousel**: Show images/content in scrollable area
- **Chat bubble**: Display conversation lines with data
- **Collapse**: Show/hide content sections
- **Countdown**: Transition effect for numbers 0-99
- **Diff**: Side-by-side comparison of two items
- **Kbd**: Display keyboard keys
- **List**: Display items in list format
- **Stat**: Show statistics and metrics
- **Status**: Display status indicators
- **Table**: Display tabular data
- **Timeline**: Show chronological events

## Navigation (8 components)
- **Breadcrumbs**: Help users navigate through website
- **Dock**: Navigation dock interface
- **Link**: Styled navigation links
- **Menu**: Navigation menu structure
- **Navbar**: Top navigation bar
- **Pagination**: Navigate through pages of content
- **Steps**: Show progress through multi-step process
- **Tab**: Tabbed navigation interface

## Feedback (7 components)
- **Alert**: Inform users about important events
- **Loading**: Show loading states
- **Progress**: Display progress bars
- **Radial progress**: Circular progress indicators
- **Skeleton**: Loading placeholder content
- **Toast**: Show temporary notifications
- **Tooltip**: Display helpful hints on hover

## Data Input (14 components)
- **Calendar**: Date/time picker interface
- **Checkbox**: Select/deselect values
- **Fieldset**: Group related form fields
- **File Input**: File upload interface
- **Filter**: Filter/search interface
- **Label**: Form field labels
- **Radio**: Single selection from options
- **Range**: Slider input for ranges
- **Rating**: Star/rating input
- **Select**: Dropdown selection
- **Input field**: Text input fields
- **Textarea**: Multi-line text input
- **Toggle**: On/off switch
- **Validator**: Form validation display

## Layout (8 components)
- **Divider**: Separate content vertically/horizontally
- **Drawer**: Sliding side panel
- **Footer**: Page footer layout
- **Hero**: Large banner/header section
- **Indicator**: Notification indicators
- **Join**: Group related elements
- **Mask**: Shape/image masking
- **Stack**: Layer elements on top of each other

## Mockup (4 components)
- **Browser**: Browser window mockup
- **Code**: Code block display
- **Phone**: Mobile device mockup
- **Window**: Desktop window mockup

---

# HyperUI Components (Tailwind-based fallbacks)

Source: https://github.com/markmead/hyperui/tree/main/public/components/

When daisyUI doesn't have a suitable component, we can adapt HyperUI components using daisyUI utility classes and colors.

## Marketing Components
Source: https://github.com/markmead/hyperui/tree/main/public/components/marketing
1. **Announcements**: Notification and announcement banners
2. **Banners**: Promotional and marketing banners
3. **Blog Cards**: Blog post preview cards
4. **Buttons**: Marketing-focused button designs
5. **Cards**: Marketing content containers
6. **Carts**: Shopping cart interfaces
7. **CTAs**: Call-to-action sections
8. **FAQs**: Frequently asked questions layouts
9. **Footers**: Website footer designs
10. **Headers**: Hero sections and page headers
11. **Pricing**: Pricing tables and cards
12. **Product Cards**: E-commerce product displays
13. **Product Collections**: Product grid layouts
14. **Sections**: General marketing sections
15. **Stats**: Statistics and metrics displays

## Application Components
Source: https://github.com/markmead/hyperui/tree/main/public/components/application
1. **Alerts**: Notification and warning messages
2. **Badges**: Status and category indicators
3. **Breadcrumbs**: Navigation breadcrumb trails
4. **Button Groups**: Grouped button interfaces
5. **Checkboxes**: Checkbox input components
6. **Details List**: Detailed information displays
7. **Dividers**: Section separation elements
8. **Dropdown**: Dropdown menu interfaces
9. **File Uploaders**: File upload interfaces
10. **Filters**: Data filtering controls
11. **Grids**: Grid layout components
12. **Inputs**: Form input fields
13. **Media**: Media display components
14. **Modals**: Dialog boxes and overlays
15. **Pagination**: Page navigation controls
16. **Quantity Inputs**: Numeric quantity selectors
17. **Radio Groups**: Radio button groups
18. **Selects**: Select dropdown components
19. **Side Menu**: Sidebar navigation panels
20. **Stats**: Application statistics displays
21. **Steps**: Multi-step process indicators
22. **Tables**: Data table layouts
23. **Textareas**: Multi-line text inputs
24. **Timelines**: Chronological event displays
25. **Toggles**: Toggle switch components
26. **Vertical Menu**: Vertical navigation menus

---

# Daisy-Components Collection (Pre-built DaisyUI)

Source: https://github.com/willpinha/daisy-components/tree/master/src/collection

Additional pre-built components that are already using daisyUI:

1. **Alert**: Notification and alert components
2. **Authentication**: Login/signup forms and layouts
3. **Card**: Enhanced card components
4. **Cookies**: Cookie consent banners
5. **Dropdown**: Advanced dropdown menus
6. **FAQ**: Frequently asked questions sections
7. **Footer**: Footer layout components
8. **Hero**: Hero section designs
9. **Input**: Enhanced input field components
10. **Modal**: Modal dialog components
11. **Navbar**: Navigation bar components
12. **Pricing**: Pricing section layouts
13. **Sidebar**: Sidebar navigation components
14. **Subscribe**: Newsletter/subscription forms
15. **Team**: Team member showcase sections

## Adaptation Strategy
When using HyperUI components as fallbacks:
1. Replace Tailwind color classes with daisyUI semantic colors (primary, secondary, accent, etc.)
2. Use daisyUI component classes where available
3. Maintain responsive design patterns
4. Ensure accessibility features are preserved
5. Adapt animations to match daisyUI theme

When using Daisy-Components:
1. These are already built with daisyUI, so they can be used more directly
2. Adapt the code structure to match the decor component library patterns
3. Ensure consistency with existing decor component naming and organization

## Implementation Request Protocol
When suggesting a component from any of these collections (DaisyUI, HyperUI, or Daisy-Components), always ask the user to provide a URL to a specific implementation example so that the exact design and functionality can be reviewed and properly adapted to the decor component library.

## Component Conversion Best Practices

### Phlex Optimization Pattern
- **Single element components**: Use `render parent_element` directly with `element_classes` rather than adding another element inside parent_element's block
- Example: `render parent_element` (classes applied to parent) vs `render parent_element do; span(class: "..."); end` (extra nested element)

### Backward Compatibility Rule
- **NEVER break existing component signatures** during conversion
- Original attribute values must continue to work (can add new ones)
- Example: `color: [:white, :black]` → `color: [:white, :black, :primary, ...]` ✅

### Conversion Checklist per Component
1. Convert Ruby class (Component → PhlexComponent)
2. Add view_template method
3. Remove .html.erb file
4. Update Preview file
5. Update unit test file
6. Verify component still works

## Memory Notes
- Remember that parent_element takes element_classes, so if you just need to style one element, use that combo, like in Spinner, rather than adding another element to parent_elements block

## Rendering Lookbook Previews
- When creating lookbook previews, blocks passed to rendered components need to call methods on the component, eg do |component| component.render... or component.div(...)

## Memory Notes
- Do not use OpenStruct in tests or anywhere

## Phlex SVG Paths Memory
- For SVG `path`s in phlex do `svg(...) do |s| s.path(...) end`