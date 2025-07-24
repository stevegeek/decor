/**
 * HTTP Utilities for Decor
 * 
 * This module provides a fetch abstraction layer that can be used instead of axios
 * or other HTTP libraries. It handles CSRF tokens, common headers, and provides
 * a simple API for making HTTP requests.
 */

/**
 * Get CSRF token from meta tag
 * @returns {string} CSRF token or empty string
 */
function getCSRFToken() {
    const csrfMetaTag = document.head.querySelector('[name="csrf-token"]');
    return (csrfMetaTag && csrfMetaTag.getAttribute("content")) || "";
}

/**
 * Default headers for requests
 * @returns {Object} Headers object with CSRF token
 */
function getDefaultHeaders() {
    return {
        "X-CSRF-TOKEN": getCSRFToken(),
    };
}

/**
 * Make an HTTP request using the native fetch API
 * @param {string} url - The URL to request
 * @param {Object} options - Fetch options
 * @returns {Promise} Promise that resolves with the response
 */
async function request(url, options = {}) {
    const defaultOptions = {
        headers: {
            ...getDefaultHeaders(),
            ...options.headers,
        },
        credentials: 'same-origin', // Include cookies for same-origin requests
    };

    const fetchOptions = { ...defaultOptions, ...options };
    
    try {
        const response = await fetch(url, fetchOptions);
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        return response;
    } catch (error) {
        // Re-throw the error for consistent error handling
        throw error;
    }
}

/**
 * Make a GET request
 * @param {string} url - The URL to request
 * @param {Object} options - Additional options
 * @returns {Promise} Promise that resolves with the response
 */
export async function get(url, options = {}) {
    return request(url, {
        method: 'GET',
        ...options,
    });
}

/**
 * Make a POST request
 * @param {string} url - The URL to request
 * @param {Object|string} data - Data to send in request body
 * @param {Object} options - Additional options
 * @returns {Promise} Promise that resolves with the response
 */
export async function post(url, data, options = {}) {
    const headers = { ...options.headers };
    let body = data;
    
    // If data is an object, stringify it and set content-type
    if (data && typeof data === 'object' && !(data instanceof FormData)) {
        headers['Content-Type'] = 'application/json';
        body = JSON.stringify(data);
    }
    
    return request(url, {
        method: 'POST',
        body,
        headers,
        ...options,
    });
}

/**
 * Make a GET request for HTML content
 * @param {string} url - The URL to request
 * @returns {Promise<string>} Promise that resolves with HTML text
 */
export async function getHTML(url) {
    const response = await get(url, {
        headers: {
            'Content-Type': 'text/html',
            'Accept': 'text/html',
        },
    });
    return response.text();
}

/**
 * Make a GET request for JSON content
 * @param {string} url - The URL to request
 * @returns {Promise<Object>} Promise that resolves with parsed JSON
 */
export async function getJSON(url) {
    const response = await get(url, {
        headers: {
            'Accept': 'application/json',
        },
    });
    return response.json();
}

/**
 * Create a configured HTTP client instance
 * This mimics the createAxiosInstance function but returns an object
 * with methods that use the fetch API
 * @returns {Object} HTTP client with configured methods
 */
export function createHTTPClient() {
    return {
        get: (url, config = {}) => {
            // Map axios-style config to fetch options
            const { headers = {}, ...otherConfig } = config;
            return get(url, { headers, ...otherConfig }).then(response => ({
                data: null, // Will be populated based on response type
                status: response.status,
                statusText: response.statusText,
                headers: response.headers,
                config: config,
                request: response,
                // Handle response data based on content type
                _processResponse: async () => {
                    const contentType = response.headers.get('content-type');
                    if (contentType && contentType.includes('application/json')) {
                        return { ...response, data: await response.json() };
                    } else {
                        return { ...response, data: await response.text() };
                    }
                }
            })).then(result => result._processResponse());
        },
        post: (url, data, config = {}) => {
            const { headers = {}, ...otherConfig } = config;
            return post(url, data, { headers, ...otherConfig }).then(response => ({
                data: null,
                status: response.status,
                statusText: response.statusText,
                headers: response.headers,
                config: config,
                request: response,
                _processResponse: async () => {
                    const contentType = response.headers.get('content-type');
                    if (contentType && contentType.includes('application/json')) {
                        return { ...response, data: await response.json() };
                    } else {
                        return { ...response, data: await response.text() };
                    }
                }
            })).then(result => result._processResponse());
        }
    };
}

