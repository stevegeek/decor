import DaisyCodeBlockController from "../daisy/code_block_controller";

// Suite sidecar for the code-block Stimulus controller. The Suite Ruby
// component (Decor::Suite::CodeBlock) emits its data-controller / target /
// value attributes under the `decor--suite--code-block` identifier; this
// subclass gives that identifier its own class identity so the Suite variant
// can diverge without forking the Daisy behaviour. Behaviour is currently
// identical.
export default class SuiteCodeBlockController extends DaisyCodeBlockController {}
