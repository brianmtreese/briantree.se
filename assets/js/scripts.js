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

		// DOM COM Show carousel: Scroll videos into view when clicked
		var carouselVideos = document.querySelectorAll(".dom-com-carousel__video");
		var carouselWrapper = document.querySelector(".dom-com-carousel-wrapper");
		
		if (carouselVideos.length > 0 && carouselWrapper) {
			// Helper function to check if element is fully visible in scroll container
			function isFullyVisible(element, scrollContainer) {
				var elementRect = element.getBoundingClientRect();
				var containerRect = scrollContainer.getBoundingClientRect();
				
				return (
					elementRect.left >= containerRect.left &&
					elementRect.right <= containerRect.right &&
					elementRect.top >= containerRect.top &&
					elementRect.bottom <= containerRect.bottom
				);
			}

			// Update visibility state for all videos
			function updateVisibility() {
				carouselVideos.forEach(function(videoContainer) {
					if (isFullyVisible(videoContainer, carouselWrapper)) {
						videoContainer.classList.add("is-visible");
					} else {
						videoContainer.classList.remove("is-visible");
					}
				});
			}

			// Initial visibility check
			updateVisibility();

			// Update on scroll
			carouselWrapper.addEventListener("scroll", updateVisibility);
			
			// Update on resize
			window.addEventListener("resize", updateVisibility);

			// Add click handler to overlay
			carouselVideos.forEach(function(videoContainer) {
				var overlay = videoContainer.querySelector(".dom-com-carousel__click-overlay");
				if (overlay) {
					overlay.addEventListener("click", function(e) {
						// Check if video container has is-visible class (set by updateVisibility)
						// This is more reliable than checking visibility at click time
						if (videoContainer.classList.contains("is-visible")) {
							// Video is visible, don't intercept - let click pass through to iframe
							return;
						}
						
						// Video is not fully visible, scroll it into view and then play
						var carouselItem = videoContainer.closest(".dom-com-carousel__item");
						var iframe = videoContainer.querySelector("iframe");
						
						if (carouselItem && iframe) {
							e.preventDefault();
							e.stopPropagation();
							
							// Store original src to add autoplay later
							var originalSrc = iframe.src;
							var hasAutoplay = originalSrc.indexOf("autoplay=1") !== -1;
							
							// Scroll the video into view
							carouselItem.scrollIntoView({
								behavior: "smooth",
								block: "nearest",
								inline: "center"
							});
							
							// After scroll completes, update visibility and start playing
							setTimeout(function() {
								updateVisibility();
								
								// Add autoplay parameter to start playing
								if (!hasAutoplay) {
									var separator = originalSrc.indexOf("?") !== -1 ? "&" : "?";
									iframe.src = originalSrc + separator + "autoplay=1";
								}
							}, 600);
						}
					});
				}
			});
		}
	});
})();


