import { Controller } from "@hotwired/stimulus"

/**
 * Progress Controller
 * 
 * Controls an individual progress component, allowing state changes and smooth animations.
 * Handles CSS class management for progress transitions and value updates.
 * 
 * @extends Controller
 */
export default class extends Controller {
  static targets = ["progress", "step"];

  static values = { 
    currentStep: { type: Number, default: 1 },
    totalSteps: Number
  }

  connect() {
    this.updateProgress()
  }

  handleStepChanged(event) {
    const { currentStep, totalSteps } = event.detail;
    this.currentStepValue = currentStep;
    if (totalSteps) {
      this.totalStepsValue = totalSteps;
    }
    this.updateProgress();
  }

  // Update the progress based on current step
  updateProgress() {
    const progressPercentage = this.calculateProgressPercentage();
    
    // Update progress bar if present
    if (this.hasProgressTarget) {
      this.updateProgressBar(progressPercentage);
    }
    // Update step indicators if present
    if (this.hasStepTarget) {
      this.updateStepIndicators();
    }

    // Dispatch custom event
    this.dispatch('updated', {
      detail: {
        currentStep: this.currentStepValue,
        percentage: progressPercentage,
        totalSteps: this.totalStepsValue
      }
    });
  }

  updateProgressBar(progressPercentage) {
    const progressBar = this.progressTarget;
    if (progressBar) {
      progressBar.value = progressPercentage;
      progressBar.setAttribute('aria-label', `Progress: ${progressPercentage}% complete`);
      progressBar.classList.add('transition-all', 'duration-300');
    }
  }

  // Update step visual states
  updateStepIndicators() {
    const steps = this.stepTargets;
    steps.forEach((step, index) => {
      const stepNumber = index + 1;

      console.log(`Updating step ${stepNumber} for current step ${this.currentStepValue}`);
      // Remove existing state classes
      step.classList.remove('step-primary', 'step-secondary', 'step-accent', 
                           'step-success', 'step-error', 'step-warning', 'step-info');
      
      // Add appropriate state class based on progress
      if (stepNumber <= this.currentStepValue) {
        // Get the color from the progress element's class
        const colorClass = this.getProgressColor();
        if (colorClass) {
          step.classList.add(`step-${colorClass}`);
        } else {
          step.classList.add('step-primary');
        }
      }
      
      // Update data-content for completed steps
      if (stepNumber < this.currentStepValue) {
        step.setAttribute('data-content', '✓');
      } else if (step.hasAttribute('data-content') && step.getAttribute('data-content') === '✓') {
        step.setAttribute('data-content', stepNumber.toString());
      }
    })
  }

  // Calculate progress percentage
  calculateProgressPercentage() {
    if (this.currentStepValue <= 0) return 0;
    if (this.currentStepValue > this.totalStepsValue) return 100;
    
    return Math.round((this.currentStepValue / this.totalStepsValue) * 100);
  }

  // Extract color from progress element classes
  getProgressColor() {
    const progressBar = this.element.querySelector('progress');
    if (!progressBar) return null;
    
    const colors = ['primary', 'secondary', 'accent', 'success', 'error', 'warning', 'info'];
    for (const color of colors) {
      if (progressBar.classList.contains(`progress-${color}`)) {
        return color;
      }
    }
    return null;
  }

  // Public methods for external control
  setStep(step) {
    this.currentStepValue = Math.max(0, Math.min(step, this.totalStepsValue + 1));
    this.updateProgress();
  }

  nextStep() {
    if (this.currentStepValue < this.totalStepsValue + 1) {
      this.currentStepValue++;
      this.updateProgress();
    }
  }

  previousStep() {
    if (this.currentStepValue > 0) {
      this.currentStepValue--;
      this.updateProgress();
    }
  }

  reset() {
    this.currentStepValue = 1
    this.updateProgress();
  }

  complete() {
    this.currentStepValue = this.totalStepsValue + 1;
    this.updateProgress();
  }
}