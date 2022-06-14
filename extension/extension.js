const SQUASH_MERGE_DESC_ATTR = 'data-squash-merge-desc';

const wait = (durationMS) => new Promise(resolve => setTimeout(resolve, durationMS));
const waitForSelector = async (selector) => {
	const waitTime = 20;
	const logEvery = 50;
	let attempt = 1;
	while (true) {
		const $res = document.querySelector(selector);
		if ($res) return $res;
		if (attempt % logEvery === 0) {
			console.log(`Trying to find ${selector}`);
		}
		++attempt;
		await wait(waitTime);
	}
}

async function onClick() {
	// Give a little bit of time to the form to open
	await wait(50);

	// Scroll to top
	window.scrollTo(0, 0);

	// Click PR description edit button to populate the form
	const $prDescEditButton = document.querySelector('.js-comment-edit-button');
	$prDescEditButton.click();

	// Get PR description
	const $textarea = await waitForSelector('textarea[name="pull_request[body]"]');
	const prDescription = $textarea.value;
	console.log("Found textarea, value = ", prDescription);

	// Click PR description cancel button
	const $prDescCancelButton = await waitForSelector('.js-comment-cancel-button');
	$prDescCancelButton.click();
	await wait(50); // Give it some time to close

	// Fill PR merge message textarea
	const $prMergeTextarea = await waitForSelector('#merge_message_field');
	$prMergeTextarea.value = prDescription;
	// Expand the textarea to fill the whole contents
	$prMergeTextarea.style.height = 'auto';
	$prMergeTextarea.style.height = Math.min($prMergeTextarea.scrollHeight, 512) + 'px';

	// Scroll to merge area
	const scrollTop = $prMergeTextarea.getBoundingClientRect().top - 170;
	window.scrollTo(0, scrollTop);
}

(async () => {
	while (true) {
		await wait(1000);
		if (!document.location.href.includes('/pull/')) continue;
		const $squashButton = document.querySelector('button.btn-group-squash[data-details-container=".js-merge-pr"]');
		if (!$squashButton) continue;
		if ($squashButton.getAttribute(SQUASH_MERGE_DESC_ATTR)) continue;
		$squashButton.addEventListener('click', onClick);
		$squashButton.setAttribute(SQUASH_MERGE_DESC_ATTR, 'set');
	}
})();
