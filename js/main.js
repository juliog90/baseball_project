var matchId;
var teamId;
function init() {
  let apiUrl = "http://localhost/baseball_project/src/";
  //create request object
  let x = new XMLHttpRequest();

  var param = 2;
  matchId = param;

  //prepare request
  x.open('GET',apiUrl + 'matches/' + param);

  //request headers
  /*x.setRequestHeader('username',document.getElementById('username').value);
  x.setRequestHeader('password',document.getElementById('password').value);*/

  //send request
  x.send();
  //onreadystatechange event handler
  x.onreadystatechange = function(){
    //readyState = 4 : bak with info    
    //status = 200 : OK
    //status = 404 : Page not found (check API url)
    //status = 500 : Request denied by server (check API Access-ControlAllow)
    if(x.readyState == 4 & x.status == 200){
      console.log(x.responseText);
      var jsonResponse = JSON.parse(x.responseText);
      if(jsonResponse.status == 0){
        //grant access
        /*document.getElementById('error').style.display = 'none';*/
      }else{
        // document.getElementById('error').innerHTML = jsonResponse.errorMessage;
        // document.getElementById('error').style.display = 'block';

      }

      var idHome = jsonResponse.matches.homeTeam;
      var idGuest = jsonResponse.matches.guestTeam;
      changuePhoto(idGuest);
      
      var combo = document.getElementById('number');
      combo.addEventListener('onchange', function() { changuePhoto(this) }, false);

      loadTeam(idHome);
      loadTeam(idGuest);

      var combox = document.getElementById('number');
    }
  }
}category

function val()
{
  var id = document.getElementById("number").value;
  changuePhoto(id);

}

function loadTeam(idTeam) {
  let apiUrl = "http://localhost/baseball_project/src/";
  //create request object
  let t = new XMLHttpRequest();

  var param = idTeam;

  //prepare request
  t.open('GET',apiUrl + 'team/' + param);

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

function loadCombo(team1)
{
  var combo = document.getElementById("number");
  var option = document.createElement("option");
  option.value = team1.team.id;
  option.innerHTML = team1.team.name;

  combo.appendChild(option);
}

function changuePhoto(teamId)
{
  let apiUrl = "http://localhost/baseball_project/src/";
  //create request object
  let t = new XMLHttpRequest();

  var param = teamId;

  //prepare request
  t.open('GET',apiUrl + 'team/' + param);

  //request headers
  /*t.setRequestHeader('username',document.getElementById('username').value);
    t.setRequestHeader('password',document.getElementById('password').value);*/

  //send request
  t.send();

  //onreadystatechange event handler
  t.onreadystatechange = function(){
    //readyState = 4 : bak with info    
    //status = 200 : OK
    //status = 404 : Page not found (check API url)
    //status = 500 : Request denied by server (check API Access-ControlAllow)
    if(t.readyState == 4 & t.status == 200){
      var teamResponse = JSON.parse(t.responseText);
      console.log(teamResponse);
      if(teamResponse.status == 0){
        //grant access
        /*document.getElementById('error').style.display = 'none';*/
      }else{
        // document.getElementById('error').innerHTML = teamResponse.errorMessage;
        // document.getElementById('error').style.display = 'block';

      }

      loadFrame(teamResponse);
    }
  }
}

function loadFrame(teamSelected)
{
  var imgFrame = document.getElementById('teamBigPhoto');
  var divData = document.getElementById('data')
  var category = document.createElement('label');
  category.innerHTML = teamSelected.team.category.name;
  imgFrame.src = teamSelected.team.image;
  teamId = teamSelected.team.id;
}

function loadPage(){
		window.location.href="list.html?mat="+matchId+"?team="+teamId;
	}
