import { Controller } from "@hotwired/stimulus";

/**
 * Modern Google Maps controller using the 2024/2025 JavaScript API loading approach
 * 
 * Features:
 * - Uses modern async/await pattern with dynamic library imports
 * - CSP-compliant loading without dynamic script injection
 * - Automatic prevention of multiple API loads
 * - Modular loading of only needed libraries
 * - Enhanced security and error handling
 * - XSS protection through input sanitization
 * 
 * @extends Controller
 */
export default class extends Controller {
  static targets = ["mapContainer"];
  static values = {
    apiKey: String,
    zoom: { type: String, default: null },
    points: Array,
    overlays: { type: String, default: null },
    center: { type: String, default: null },
    interactive: { type: Boolean, default: true },
    showControls: { type: Boolean, default: true },
    mapType: { type: String, default: 'roadmap' },
  };

  connect() {
    this.loadingState = false;
    this.errorState = false;
    this.markers = [];
    this.overlays = [];
    this.mapsLibrary = null;
    this.markerLibrary = null;
    
    this.initializeGoogleMaps();
  }

  disconnect() {
    this.cleanup();
  }

  async initializeGoogleMaps() {
    try {
      console.log('Initializing Google Maps with modern API loading...');
      this.showLoadingState();
      
      // Validate API key
      const apiKey = this.apiKeyValue;
      if (!apiKey) {
        throw new Error('Google Maps API key is required');
      }

      // Initialize Google Maps using the modern bootstrap loader
      await this.loadGoogleMapsAPI(apiKey);
      
      // Load required libraries dynamically
      await this.loadRequiredLibraries();

      console.log('Google Maps libraries loaded successfully, proceeding to create map...');
      // Initialize the map
      await this.createMap();
      
      // Add overlays and markers
      await this.addOverlays();
      await this.addPoints();
      
      this.hideLoadingState();
    } catch (error) {
      this.handleError('Failed to initialize Google Maps', error);
    }
  }

  async loadGoogleMapsAPI(apiKey) {
    console.log('🔍 Checking if Google Maps is already loaded...');
    
    // Check if Google Maps is already loaded
    if (window.google && window.google.maps) {
      console.log('✅ Google Maps already loaded, skipping');
      return;
    }

    console.log('📥 Google Maps not loaded, initializing with modern approach...');

    // Modern approach: Load just the bootstrap, then use importLibrary
    return new Promise((resolve, reject) => {
      // Check if already loading
      if (document.getElementById('google-maps-api-script')) {
        console.log('⏳ Script already loading, waiting...');
        // Wait for existing script to load
        const checkLoaded = () => {
          if (window.google && window.google.maps) {
            resolve();
          } else {
            setTimeout(checkLoaded, 100);
          }
        };
        checkLoaded();
        return;
      }

      // Set up a unique callback name
      const callbackName = `initGoogleMaps_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
      
      console.log(`🔗 Setting up callback: ${callbackName}`);
      
      // Create the callback function
      window[callbackName] = () => {
        console.log('✅ Google Maps bootstrap loaded via callback');
        delete window[callbackName]; // Clean up
        resolve();
      };

      // Create script element for modern loading (no libraries in URL)
      const script = document.createElement('script');
      script.type = 'text/javascript';
      script.async = true;
      script.defer = true;
      script.id = 'google-maps-api-script';
      
      // Load just the bootstrap without libraries (will use importLibrary later)
      script.src = `https://maps.googleapis.com/maps/api/js?key=${encodeURIComponent(apiKey)}&callback=${callbackName}&v=weekly`;
      
      console.log('📡 Loading Google Maps bootstrap from:', script.src);

      script.onerror = (error) => {
        console.error('❌ Failed to load Google Maps script:', error);
        delete window[callbackName]; // Clean up on error
        reject(new Error('Failed to load Google Maps API script'));
      };

      // Add timeout for safety
      const timeout = setTimeout(() => {
        console.error('⏰ Timeout loading Google Maps API');
        delete window[callbackName];
        reject(new Error('Timeout loading Google Maps API'));
      }, 15000); // 15 second timeout

      // Clear timeout when callback is called
      const originalCallback = window[callbackName];
      window[callbackName] = () => {
        clearTimeout(timeout);
        originalCallback();
      };

      // Add to document head
      const head = document.head || document.getElementsByTagName('head')[0];
      console.log('📎 Adding script to document head');
      head.appendChild(script);
    });
  }

  async loadRequiredLibraries() {
    try {
      // Load Maps library for core Map functionality
      this.mapsLibrary = await google.maps.importLibrary("maps");
      
      // Load Marker library for marker functionality
      this.markerLibrary = await google.maps.importLibrary("marker");
    } catch (error) {
      throw new Error(`Failed to load Google Maps libraries: ${error.message}`);
    }
  }

  async createMap() {
    if (!this.mapContainerTarget) {
      throw new Error('Map container not found');
    }

    if (!this.mapsLibrary) {
      throw new Error('Maps library not loaded');
    }

    try {
      const mapOptions = {
        center: this.mapCenter,
        zoom: parseInt(this.zoomValue || "10", 10),
        disableDefaultUI: !this.showControlsValue,
        gestureHandling: this.interactiveValue ? 'auto' : 'none',
        mapTypeId: this.mapTypeIdValue || 'roadmap'
      };

      // Use the modern Map constructor from the loaded library
      this.googleMap = new this.mapsLibrary.Map(this.mapContainerTarget, mapOptions);
      
      // Add map event listeners for loading completion
      this.googleMap.addListener('tilesloaded', () => {
        this.hideLoadingState();
      });

      // Add error listener for map tiles
      this.googleMap.addListener('error', (error) => {
        this.handleError('Map tiles failed to load', error);
      });

    } catch (error) {
      throw new Error(`Failed to create map: ${error.message}`);
    }
  }

  async addPoints() {
    const pointsData = this.pointsValue;
    if (!pointsData || !Array.isArray(pointsData)) {
      return;
    }

    if (!this.markerLibrary) {
      console.warn('Marker library not loaded, skipping markers');
      return;
    }

    // Clear existing markers
    this.clearMarkers();

    for (const location of pointsData) {
      try {
        if (!this.isValidLocation(location)) {
          console.warn('Invalid location data:', location);
          continue;
        }

        // Use modern Marker constructor
        const marker = new google.maps.Marker({
          position: { 
            lat: parseFloat(location.lat), 
            lng: parseFloat(location.lng) 
          },
          title: this.sanitizeText(`${location.description || ''} (${location.name || ''})`),
          map: this.googleMap
        });

        // Add info window if there's description or name
        if (location.description || location.name) {
          const infoWindow = new google.maps.InfoWindow({
            content: this.createInfoWindowContent(location)
          });

          marker.addListener('click', () => {
            // Close other info windows
            this.closeAllInfoWindows();
            infoWindow.open(this.googleMap, marker);
            this.currentInfoWindow = infoWindow;
          });
        }

        this.markers.push(marker);
      } catch (error) {
        console.error('Failed to add marker:', error);
      }
    }
  }

  async addOverlays() {
    const overlaysData = this.overlaysValue;
    if (!overlaysData) {
      return;
    }

    // Clear existing overlays
    this.clearOverlays();

    try {
      const regions = Array.isArray(overlaysData) ? overlaysData : JSON.parse(overlaysData);
      
      for (const region of regions) {
        try {
          if (!region.coordinates) {
            console.warn('Region missing coordinates:', region);
            continue;
          }

          const paths = region.coordinates.flatMap((polygon) => {
            return polygon.flatMap((path) => {
              return path.map((point) => {
                // Important: the lat/lng are vice-versa in GeoJSON
                return new google.maps.LatLng(
                  parseFloat(point[1]), 
                  parseFloat(point[0])
                );
              });
            });
          });

          const mapPolygon = new google.maps.Polygon({ 
            paths,
            strokeColor: '#FF0000',
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: '#FF0000',
            fillOpacity: 0.35
          });
          
          mapPolygon.setMap(this.googleMap);
          this.overlays.push(mapPolygon);
        } catch (error) {
          console.error('Failed to add overlay:', error);
        }
      }
    } catch (error) {
      console.error("Could not render the map overlays", error.message);
      this.handleError('Failed to render map overlays', error);
    }
  }

  get mapCenter() {
    const centerData = this.centerValue;
    if (!centerData) {
      return this.getDefaultCenter();
    }

    try {
      const center = typeof centerData === 'string' ? JSON.parse(centerData) : centerData;
      
      if (!this.isValidLocation(center)) {
        console.warn('Invalid center coordinates, using default');
        return this.getDefaultCenter();
      }
      
      return { 
        lat: parseFloat(center.lat), 
        lng: parseFloat(center.lng) 
      };
    } catch (error) {
      console.warn('Failed to parse center coordinates, using default:', error);
      return this.getDefaultCenter();
    }
  }

  getDefaultCenter() {
    // Default to San Francisco for better neutrality
    return { lat: 37.7749, lng: -122.4194 };
  }

  // Security: Sanitize user input to prevent XSS
  sanitizeText(text) {
    if (!text || typeof text !== 'string') return '';
    
    // Create a temporary div to leverage browser's HTML entity encoding
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  // Create safe info window content
  createInfoWindowContent(location) {
    const content = document.createElement('div');
    content.className = 'map-info-window';
    
    if (location.name) {
      const title = document.createElement('h3');
      title.textContent = location.name;
      title.className = 'text-lg font-semibold mb-2';
      content.appendChild(title);
    }
    
    if (location.description) {
      const description = document.createElement('p');
      description.textContent = location.description;
      description.className = 'text-sm text-gray-600';
      content.appendChild(description);
    }
    
    return content;
  }

  // Validation helper
  isValidLocation(location) {
    return location && 
           typeof location.lat !== 'undefined' && 
           typeof location.lng !== 'undefined' &&
           !isNaN(parseFloat(location.lat)) && 
           !isNaN(parseFloat(location.lng)) &&
           isFinite(location.lat) && 
           isFinite(location.lng);
  }

  // Loading state management
  showLoadingState() {
    this.loadingState = true;
    this.mapContainerTarget.classList.add('map-loading');
    this.mapContainerTarget.setAttribute('aria-busy', 'true');
  }

  hideLoadingState() {
    this.loadingState = false;
    this.mapContainerTarget.classList.remove('map-loading');
    this.mapContainerTarget.removeAttribute('aria-busy');
  }

  // Enhanced error handling for modern API
  handleError(message, error = null) {
    this.errorState = true;
    this.hideLoadingState();
    
    console.error(message, error);
    
    // Determine error type for better user messaging
    let userMessage = 'Failed to load map';
    if (error && error.message) {
      if (error.message.includes('API key')) {
        userMessage = 'Invalid or missing API key';
      } else if (error.message.includes('quota') || error.message.includes('billing')) {
        userMessage = 'API quota exceeded or billing issue';
      } else if (error.message.includes('network') || error.message.includes('load')) {
        userMessage = 'Network error - please check connection';
      }
    }
    
    // Show user-friendly error message
    if (this.mapContainerTarget) {
      this.mapContainerTarget.classList.add('map-error');
      this.mapContainerTarget.innerHTML = `
        <div class="flex items-center justify-center h-full bg-gray-50 text-gray-600">
          <div class="text-center p-4">
            <svg class="mx-auto h-12 w-12 text-gray-300 mb-4" fill="none" stroke="currentColor" viewBox="0 0 48 48">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
            <p class="text-sm font-medium">${userMessage}</p>
            <p class="text-xs text-gray-500 mt-2">Please check console for details</p>
          </div>
        </div>
      `;
    }
    
    // Dispatch error event for parent components to handle
    this.dispatch('error', { detail: { message, error, userMessage } });
  }

  // Info window management
  closeAllInfoWindows() {
    if (this.currentInfoWindow) {
      this.currentInfoWindow.close();
      this.currentInfoWindow = null;
    }
  }

  // Cleanup helpers
  clearMarkers() {
    this.markers.forEach(marker => {
      marker.setMap(null);
    });
    this.markers = [];
  }

  clearOverlays() {
    this.overlays.forEach(overlay => {
      overlay.setMap(null);
    });
    this.overlays = [];
  }

  cleanup() {
    this.closeAllInfoWindows();
    this.clearMarkers();
    this.clearOverlays();
    
    if (this.googleMap) {
      this.googleMap = null;
    }
    
    this.mapsLibrary = null;
    this.markerLibrary = null;
    this.loadingState = false;
    this.errorState = false;
  }

  // Map type conversion helper
  get mapTypeIdValue() {
    const mapType = this.mapTypeValue || 'roadmap';
    const typeMap = {
      'roadmap': 'roadmap',
      'satellite': 'satellite',
      'hybrid': 'hybrid',
      'terrain': 'terrain'
    };
    return typeMap[mapType] || 'roadmap';
  }
}