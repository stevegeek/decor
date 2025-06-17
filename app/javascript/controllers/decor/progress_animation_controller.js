import { Controller } from "@hotwired/stimulus"

/**
 * Progress Animation Controller
 * 
 * Automatically cycles through progress values to demonstrate animated transitions.
 * Used in preview examples to show the progress component animation in action.
 * 
 * @extends Controller
 */
export default class extends Controller {
  static values = {
    currentStep: { type: Number, default: 2 },
    steps: { type: Number, default: 5 },
    speed: { type: Number, default: 2000 }, // milliseconds between steps
    direction: { type: String, default: "forward" } // "forward" or "reverse"
  }

  connect() {
    this.currentStep = this.currentStepValue;
    this.isForward = this.directionValue === "forward";
    this.startAnimation();
  }

  disconnect() {
    this.stopAnimation();
  }

  startAnimation() {
    this.stopAnimation(); // Clear any existing interval
    this.interval = setInterval(() => {
      this.updateProgress();
    }, this.speedValue);
  }

  stopAnimation() {
    if (this.interval) {
      clearInterval(this.interval);
      this.interval = null;
    }
  }

  updateProgress() {
    // Calculate next step based on direction
    if (this.isForward) {
      this.currentStep++;
      if (this.currentStep > this.stepsValue) {
        this.currentStep = this.stepsValue;
        this.isForward = false;
      }
    } else {
      this.currentStep--;
      if (this.currentStep < 1) {
        this.currentStep = 1;
        this.isForward = true;
      }
    }
    console.log(`Dispatch: Current Step: ${this.currentStep}, Total Steps: ${this.stepsValue}`);
    // Dispatch step change event to each progress element inside
    this.dispatch('changed', {
      detail: {
        prefix: 'decor--progress-animation',
        currentStep: this.currentStep,
        totalSteps: this.stepsValue
      }
    });
  }

  // Allow manual control
  pause() {
    this.stopAnimation();
  }

  resume() {
    this.startAnimation();
  }

  reset() {
    this.currentStep = 1;
    this.isForward = true;
    this.updateProgress();
  }
}