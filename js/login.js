function login(){
  let apiUrl = "http://localhost/baseballProject/src/";
  console.log('login...');
  //create request object
  let x = new XMLHttpRequest();

  //prepare request
  x.open('GET',apiUrl + 'user/');

  //request headers
  x.setRequestHeader('username',document.getElementById('username').value);
  x.setRequestHeader('password',document.getElementById('password').value);

  //send request
  x.send();

  //onreadystatechange event handler
  x.onreadystatechange = function(){
    //readyState = 4 : bak with info    
    //status = 200 : OK
    //status = 404 : Page not found (check API url)
    //status = 500 : Request denied by server (check API Access-ControlAllow)
    if(x.readyState == 4 & x.status == 200){
      var jsonResponse = JSON.parse(x.responseText);
      console.log(jsonResponse);
      if(jsonResponse.status == 0){
        //grant access
        document.getElementById('error').style.display = 'none';
      }else{
        document.getElementById('error').innerHTML = jsonResponse.errorMessage;
        document.getElementById('error').style.display = 'block';

      }

    }
  }
}
