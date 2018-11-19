function initSignInOnClick() {
  const form = document.querySelector('#new_user');
  if (form) {
    document.querySelector('#sign-in-btn').addEventListener('click', () => {
      form.submit();
    });
  }
}

function initSignInOnEnter() {
  const form = document.querySelector('#new_user');
  if (form) {
    document.querySelector('#user_password').addEventListener('keyup', function(event) {
      if (event.keyCode === 13) {
        document.getElementById("sign-in-btn").click();
      }
    });
  }
}


export { initSignInOnClick };
export { initSignInOnEnter };
