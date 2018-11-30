function sumTotal() {
  const totals = document.querySelectorAll('.order-item-total')
  const shippingString = document.querySelector('.order-item-shipping')
  if (totals) {
    var nums = [];
    var sum = 0
    totals.forEach ((total) => {
      const value = parseFloat(total.innerHTML.substring(1))
      nums.push(value)
    });
    if (shippingString) {
      const shippingTotal = parseFloat(shippingString.innerHTML)
      nums.push(shippingTotal)
    };
    console.log(nums)
    nums.forEach ((num) => {
      sum += num
    })
    const totalsum = document.querySelector('.total-sum')
    if (totalsum) {
      totalsum.innerHTML = sum.toFixed(2)
    }
  };
};

export { sumTotal };
