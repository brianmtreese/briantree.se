// Auto-refresh script for Jekyll development
// Polls the server every 2 seconds and refreshes when the page is rebuilt

(function() {
	'use strict';
	
	// Only run in development
	if (typeof window.JEKYLL_ENV === 'undefined' || window.JEKYLL_ENV === 'production') {
		return;
	}
	
	var currentLastModified = null;
	
	// Check if page has been updated
	function checkForUpdates() {
		fetch(window.location.href, {
			method: 'HEAD',
			cache: 'no-store'
		})
		.then(function(response) {
			if (!response.ok) return;
			
			var newLastModified = response.headers.get('Last-Modified');
			
			if (currentLastModified && newLastModified && newLastModified !== currentLastModified) {
				window.location.reload();
				return;
			}
			
			if (newLastModified) {
				currentLastModified = newLastModified;
			}
		})
		.catch(function() {
			// Silently fail
		});
	}
	
	// Start checking after page loads
	setTimeout(function() {
		checkForUpdates();
		setInterval(checkForUpdates, 2000);
	}, 2000);
})();

