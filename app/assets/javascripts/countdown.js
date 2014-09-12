// adapted from http://stackoverflow.com/questions/10234939/add-a-javascript-display-to-the-home-page-to-count-down-from-140-characters-ra

function updateCountdown() {
	// 140 is the max message length
	var remaining = 140 - jQuery('#micropost_content').val().length;
	jQuery('.countdown').text(remaining);
}

jQuery(document).ready(function($) {
	updateCountdown();
	$('#micropost_content').change(updateCountdown);
	$('#micropost_content').keyup(updateCountdown);
});