import DaisyFileUploadController from "../../daisy/forms/file_upload_controller";

// Suite sidecar for the file-upload Stimulus controller. The Suite Ruby
// component (Decor::Suite::Forms::FileUpload) emits its data-controller /
// target / value attributes under the `decor--suite--forms--file-upload`
// identifier; this subclass gives that identifier its own class identity so
// the Suite variant can diverge (e.g. different preview chrome, toast hook)
// without forking the Daisy behaviour. Behaviour is currently identical.
export default class SuiteFormsFileUploadController extends DaisyFileUploadController {}
