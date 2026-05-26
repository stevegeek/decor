// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Register the DataTable outlet shim controllers synchronously BEFORE decor.js
// loads the DataTable controller. This ensures the outlet controllers are
// already registered when Stimulus connects any DataTable element, avoiding a
// timing race where DataTable's connect() runs before its outlet controllers
// exist (causing an extra disconnect/reconnect cycle that nulls out the handler).
import DataTableRowController from "controllers/decor/suite/tables/data_table_row_controller"
import DataTableHeaderRowController from "controllers/decor/suite/tables/data_table_header_row_controller"
application.register("decor--suite--tables--data-table-row", DataTableRowController)
application.register("decor--suite--tables--data-table-header-row", DataTableHeaderRowController)

// Decor controllers come from the built bundle (decor.js). It auto-registers
// every decor controller with window.Stimulus (set by controllers/application,
// which is fully evaluated before this import runs). This replaces eager-loading
// decor's raw source, whose relative imports importmap can't resolve.
import "decor"

// Eager-load the dummy app's own controllers (e.g. event-logger).
// Note: eagerLoadControllersFrom will also discover the DataTable shim files
// above and attempt to re-register them, but Stimulus silently ignores
// duplicate registrations, so this is safe.
eagerLoadControllersFrom("controllers", application)
