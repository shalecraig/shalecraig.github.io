// TODO: this is bad/spaghetti code. Fixup?

(function() {
	// TODO: a specific class only?
	var videos = document.querySelectorAll('video.delayed, video .delayed'),
		executed = {},
		vid = videos.length - 1;
	function loadedCB(x) {
		if (executed[x.target]) return;
		executed[x.target] = true;
		// show it.
		x.target.style.opacity = 1;
	};
	for (; vid >= 0; --vid) {
		videos[vid].addEventListener('canplay', loadedCB);
	}
})();
