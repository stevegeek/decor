// bulk_modal_wiring.js
// Bridges the BulkActionsBar's "show-modal" event to the Suite Modal open event.
//
// When a `modal: true` bulk action is triggered, bulk_actions_bar_controller.js
// dispatches `decor:bulk-actions:show-modal` (cancelable) with:
//   { id: "<bar-id>-bulk-modal", contentHref: "<url-with-selected-ids>" }
//
// The Suite Modal controller listens for `decor--suite--modals--modal:open` on
// window and, when its id matches detail.id, calls showModal() then fetches
// detail.contentHref (or detail.content_href) into its body.
//
// We prevent the fallback `dialog.showModal()` (which opens the placeholder with
// no content) by calling event.preventDefault() before re-dispatching.

window.addEventListener("decor:bulk-actions:show-modal", function (event) {
  event.preventDefault(); // prevents the bare placeholder showModal() fallback

  var id = event.detail.id;
  var contentHref = event.detail.contentHref;

  window.dispatchEvent(
    new CustomEvent("decor--suite--modals--modal:open", {
      detail: { id: id, contentHref: contentHref }
    })
  );
});
