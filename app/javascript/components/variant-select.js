const variantForms = document.querySelectorAll('.js-variant-form');
variantForms.forEach((variantForm) => {
	const variantSelect = variantForm.querySelector('select');
	const formUrl = window.location.pathname;
	const $priceHolder = $('#product-price-holder');
	$('select', variantForm).on('change', function() {
		const variantId = $(this).val();
		const variantUrl = `${formUrl}?varient_id=${variantId}`;

		$priceHolder.html('<i class="fa fa-spin fa-snowflake"></i> Loading...');
		
		$priceHolder.load(`${formUrl}?varient_id=${variantId} #product-prices`);
		window.history.pushState('', '', variantUrl);


	})
});