const variantForms = document.querySelectorAll('.js-variant-form');
variantForms.forEach((variantForm) => {
	const variantSelect = variantForm.querySelector('select');
	const formUrl = window.location.pathname;
	const $priceHolder = $('#product-price-holder');
  const $imageHolder = $('#product-image-varient');
	$('select', variantForm).on('change', function() {
		const variantId = $(this).val();
		const variantUrl = `${formUrl}?varient_id=${variantId}`;

		$priceHolder.html('<i class="fa fa-spin fa-snowflake"></i> Loading...');

		$priceHolder.load(`${formUrl}?varient_id=${variantId} #product-prices`);
    $imageHolder.load(`${formUrl}?varient_id=${variantId} #product-image-varient`)
		window.history.pushState('', '', variantUrl);
	})
});
