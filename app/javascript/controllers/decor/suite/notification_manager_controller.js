import DaisyNotificationManagerController from "../daisy/notification_manager_controller";

// Suite sidecar — registers its own identifier so Suite::NotificationManager
// roots actually get a controller attached. Overrides the emitted notification
// classname to match what `Decor::Suite::Notification`-aware selectors expect.
export default class SuiteNotificationManagerController extends DaisyNotificationManagerController {
    get notificationClassName() {
        return "decor--suite--notification";
    }
}
