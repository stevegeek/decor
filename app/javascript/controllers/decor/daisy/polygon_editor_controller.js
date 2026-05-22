import { Controller } from "@hotwired/stimulus";

/**
 * Controller for drawing and editing polygons on Google Maps for
 * serviceability regions / geo-fencing. Loads the Google Maps JS API
 * (with the `drawing` library) on demand, wires a DrawingManager that
 * allows a single editable polygon, and syncs the polygon as a GeoJSON
 * MultiPolygon into a hidden input.
 *
 * @extends Controller
 */
export default class extends Controller {
  static targets = ["mapContainer", "geoJsonInput"];

  static values = {
    apiKey: String,
    zoom: { type: Number, default: 10 },
    center: { type: String, default: null },
    initialPolygon: { type: String, default: null },
  };

  initialize() {
    this.googleMap = null;
    this.drawingManager = null;
    this.currentPolygon = null;
    this.attachMapScript();
  }

  connect() {
    this.onMapReady(() => {
      this.createMap();
      this.initializeDrawingManager();
      this.loadInitialPolygon();
    });
  }

  disconnect() {
    this.cleanup();
  }

  attachMapScript() {
    if (document.getElementById("google-maps-script-tag")) {
      return;
    }
    window.__decorPolygonMapInitialised =
      this.mapInitialised.bind(this);
    const key = this.apiKeyValue;
    const src = `https://maps.googleapis.com/maps/api/js?key=${encodeURIComponent(key)}&libraries=drawing&callback=__decorPolygonMapInitialised`;

    const script = document.createElement("script");
    script.type = "text/javascript";
    script.async = true;
    script.defer = true;
    script.id = "google-maps-script-tag";
    script.src = src;
    document.head.appendChild(script);
  }

  mapInitialised() {
    window.__decorMapHasLoaded = true;
    const evt = new CustomEvent("google-maps-script:ready", {
      bubbles: true,
      cancelable: false,
    });
    document.dispatchEvent(evt);
  }

  onMapReady(callback) {
    if (window.__decorMapHasLoaded && window.google && window.google.maps) {
      return callback();
    }
    const readyListener = () => {
      callback();
      document.removeEventListener("google-maps-script:ready", readyListener);
    };
    document.addEventListener("google-maps-script:ready", readyListener);
  }

  createMap() {
    this.googleMap = new google.maps.Map(this.mapContainerTarget, {
      center: this.mapCenter,
      zoom: this.zoomValue,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
    });
  }

  initializeDrawingManager() {
    if (!this.googleMap) {
      return;
    }

    this.drawingManager = new google.maps.drawing.DrawingManager({
      drawingMode: null,
      drawingControl: true,
      drawingControlOptions: {
        position: google.maps.ControlPosition.TOP_CENTER,
        drawingModes: [google.maps.drawing.OverlayType.POLYGON],
      },
      polygonOptions: {
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35,
        editable: true,
        draggable: false,
      },
    });

    this.drawingManager.setMap(this.googleMap);

    google.maps.event.addListener(
      this.drawingManager,
      "overlaycomplete",
      (event) => {
        if (event.type === google.maps.drawing.OverlayType.POLYGON) {
          this.handlePolygonComplete(event.overlay);
        }
      },
    );
  }

  handlePolygonComplete(polygon) {
    this.clearPolygon();
    this.currentPolygon = polygon;

    if (this.drawingManager) {
      this.drawingManager.setDrawingMode(null);
    }

    polygon.setEditable(true);
    this.updateGeoJsonField();
    this.addPolygonEditListeners(polygon);
  }

  addPolygonEditListeners(polygon) {
    const path = polygon.getPath();

    google.maps.event.addListener(path, "set_at", () => {
      this.updateGeoJsonField();
    });

    google.maps.event.addListener(path, "insert_at", () => {
      this.updateGeoJsonField();
    });

    google.maps.event.addListener(path, "remove_at", () => {
      this.updateGeoJsonField();
    });
  }

  loadInitialPolygon() {
    if (!this.initialPolygonValue || !this.googleMap) {
      return;
    }

    try {
      const polygon = this.geoJsonToPolygon(this.initialPolygonValue);
      if (polygon) {
        this.currentPolygon = polygon;
        polygon.setMap(this.googleMap);
        polygon.setEditable(true);
        this.fitBoundsToPolygon(polygon);
        this.addPolygonEditListeners(polygon);
      }
    } catch (error) {
      console.error("Failed to load initial polygon:", error);
    }
  }

  geoJsonToPolygon(geoJsonString) {
    try {
      const geoJson = JSON.parse(geoJsonString);

      let coordinates;
      if (geoJson.type === "MultiPolygon") {
        coordinates = geoJson.coordinates[0];
      } else if (geoJson.type === "Polygon") {
        coordinates = geoJson.coordinates;
      } else {
        console.error("Unsupported GeoJSON type:", geoJson.type);
        return null;
      }

      // GeoJSON uses [lng, lat]; Google Maps wants [lat, lng].
      const paths = coordinates.map((ring) =>
        ring.map((coord) => new google.maps.LatLng(coord[1], coord[0])),
      );

      return new google.maps.Polygon({
        paths: paths,
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35,
        editable: true,
        draggable: false,
      });
    } catch (error) {
      console.error("Error parsing GeoJSON:", error);
      return null;
    }
  }

  polygonToGeoJson(polygon) {
    const path = polygon.getPath();
    const coordinates = [];

    // Google Maps {lat, lng} → GeoJSON [lng, lat].
    for (let i = 0; i < path.getLength(); i++) {
      const latLng = path.getAt(i);
      coordinates.push([latLng.lng(), latLng.lat()]);
    }

    // Close the linear ring.
    if (coordinates.length > 0) {
      const firstCoord = coordinates[0];
      coordinates.push([firstCoord[0], firstCoord[1]]);
    }

    // PostGIS multipolygon column expects MultiPolygon.
    const geoJson = {
      type: "MultiPolygon",
      coordinates: [[coordinates]],
    };

    return JSON.stringify(geoJson);
  }

  updateGeoJsonField() {
    if (!this.currentPolygon) {
      this.geoJsonInputTarget.value = "";
      return;
    }

    this.geoJsonInputTarget.value = this.polygonToGeoJson(this.currentPolygon);
  }

  fitBoundsToPolygon(polygon) {
    if (!this.googleMap) {
      return;
    }

    const bounds = new google.maps.LatLngBounds();
    const path = polygon.getPath();

    for (let i = 0; i < path.getLength(); i++) {
      bounds.extend(path.getAt(i));
    }

    this.googleMap.fitBounds(bounds);
  }

  clearPolygon() {
    if (this.currentPolygon) {
      this.currentPolygon.setMap(null);
      this.currentPolygon = null;
      this.updateGeoJsonField();
    }

    if (this.drawingManager) {
      this.drawingManager.setDrawingMode(
        google.maps.drawing.OverlayType.POLYGON,
      );
    }
  }

  get mapCenter() {
    if (this.centerValue) {
      try {
        const center = JSON.parse(this.centerValue);
        return { lat: center.lat, lng: center.lng };
      } catch (error) {
        console.error("Error parsing center value:", error);
      }
    }

    return { lat: 33.6265064, lng: -84.5319427 };
  }

  cleanup() {
    if (this.currentPolygon) {
      this.currentPolygon.setMap(null);
      this.currentPolygon = null;
    }

    if (this.drawingManager) {
      this.drawingManager.setMap(null);
      this.drawingManager = null;
    }

    this.googleMap = null;
  }
}
