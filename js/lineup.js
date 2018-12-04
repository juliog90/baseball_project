function init() {
  var apiUrl = "http://localhost/baseball_project/src/";

  var team = 1;
  var x = new XMLHttpRequest();
  x.open('GET', apiUrl + '/team/' + team, true);
  x.send();

  x.onreadystatechange = function(){
    if (x.readyState === 4 & x.status === 200) {
      var allTeamsJson = JSON.parse(x.responseText);
      console.log(allTeamsJson);
      if (allTeamsJson.status === 0) {
        // grant access
        document.getElementById('error').style.display = 'none';
      }
      else {
        document.getElementById('error').innerHTML = allTeamsJson.errorMessage;
        document.getElementById('error').style.display = 'block';
      }
    }
  }
}

function season() {

}

function lineup() {
  var apiUrl = "http://localhost/baseballProject/src/";

  var team = 1;
  var x = new XMLHttpRequest();
  x.open('GET', apiUrl + '/lineup/' + team, true);
  x.send();

  x.onreadystatechange = function(){
    if (x.readyState === 4 & x.status === 200) {
      var allTeamsJson = JSON.parse(x.responseText);
      console.log(allTeamsJson);
      if (allTeamsJson.status === 0) {
        // grant access
        document.getElementById('error').style.display = 'none';
      }
      else {
        document.getElementById('error').innerHTML = allTeamsJson.errorMessage;
        document.getElementById('error').style.display = 'block';
      }
    }
  }
}

function teams() {

}
