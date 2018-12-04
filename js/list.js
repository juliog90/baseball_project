function list()
{
  let parameters = getUrlVars();
  console.log(parameters);
}


function loadTeamPlayers(idTeam) {
  let apiUrl = "http://localhost/baseball_project/src/";
  //create request object
  let t = new XMLHttpRequest();

  var param = idTeam;

  //prepare request
  t.open('GET',apiUrl + 'teamplayers/' + param);

  //send request
  t.send();

  //onreadystatechange event handler
  t.onreadystatechange = function(){
    if(t.readyState == 4 & t.status == 200){
      var teamResponse = JSON.parse(t.responseText);
      console.log(teamResponse);
      if(teamResponse.status == 0){
      }else{

      }
      loadCombo(teamResponse);
    }
  }
}

function findGetParameter(parameterName) {
    var result = null,
        tmp = [];
    location.search
        .substr(1)
        .split("&")
        .forEach(function (item) {
          tmp = item.split("=");
          if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
        });
    return result;
}

function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}
