// Vanilla JavaScript - no jQuery dependency
(function() {
	'use strict';
	
	// Wait for DOM to be ready
	function domReady(fn) {
		if (document.readyState === 'loading') {
			document.addEventListener('DOMContentLoaded', fn);
		} else {
			fn();
		}
	}

	domReady(function() {
		// DropCap.js
		var dropcaps = document.querySelectorAll(".dropcap");
		if (dropcaps.length > 0 && window.Dropcap) {
			window.Dropcap.layout(dropcaps, 2);
		}

		// Responsive-Nav
		if (typeof responsiveNav !== 'undefined') {
			var nav = responsiveNav(".nav-collapse");
		}

		// Round Reading Time
		var timeElements = document.querySelectorAll(".time");
		timeElements.forEach(function(element) {
			var value = element.textContent.trim();
			var rounded = Math.round(parseFloat(value));
			if (!isNaN(rounded)) {
				element.textContent = rounded;
			}
		});
	});
})();


