import DaisyMultiImageUploadController from "../../daisy/forms/multi_image_upload_controller";

// Suite sidecar for the multi-image-upload Stimulus controller. The Suite
// Ruby component (Decor::Suite::Forms::MultiImageUpload) emits its
// data-controller / target / value attributes under the
// `decor--suite--forms--multi-image-upload` identifier; this subclass gives
// that identifier its own class identity so the Suite variant can diverge
// (e.g. different crop chrome, toast hook) without forking the Daisy
// behaviour. Behaviour is currently identical.
export default class SuiteFormsMultiImageUploadController extends DaisyMultiImageUploadController {}
