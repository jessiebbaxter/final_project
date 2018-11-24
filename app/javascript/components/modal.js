function initSignInOnClick() {
  const signUpForm = document.querySelector('#new_user');
  const signInForm = document.querySelector('#old_user');
  const signIn = document.querySelector('#signInTab.tab-pane.active')
  const signUp = document.querySelector('#signUpTab.tab-pane.active')

  if (signIn) {
    document.querySelector('#sign-in-btn').addEventListener('click', () => {
      signInForm.submit();
    });
  }
  if (signUp) {
    document.querySelector('#sign-in-btn').addEventListener('click', () => {
      signUpForm.submit();
    });
  }
}

function initSignInOnEnter() {
  const signUpForm = document.querySelector('#new_user');
  const signInForm = document.querySelector('#old_user');

  if (signIn) {
    document.querySelector('#user_password').addEventListener('keyup', function(event) {
      if (event.keyCode === 13) {
        document.getElementById("sign-in-btn").click();
      }
    });
  }
}



export { initSignInOnClick };
export { initSignInOnEnter };

