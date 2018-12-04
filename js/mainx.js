var players = [
  {
    name: {
      "id": 0,
      "firstName": "Mookie",
      "lastName": "Betts"
    }, datePla: {
      category: "Pony",
      number: 11,
      wins: 1,
      loses: 12,
      hRuns: 2,
      balls: 3,
      outs: 2,
      stoBase:3,
      img: "001.png"

    }
  },
  {
    name: {
      "id": 1,
      "firstName": "Puul",
      "lastName": "Betts"
    }, datePla: {
      category: "Amateur",
      number: 12,
      wins: 10,
      loses: 12,
      hRuns: 2,
      balls: 3,
      outs: 2,
      stoBase:3,
      img: "002.png"
    }	
  },
  {
    name: {
      "id": 2,
      "firstName": "Json",
      "lastName": "Cardenas"
    }, datePla: {
      category: "Teen",
      number: 10,
      wins: 10,
      loses: 12,
      hRuns: 2,
      balls: 3,
      outs: 2,
      stoBase:3,
      img: "003.png"
    }	
  },
  {
    name: {
      "id": 3,
      "firstName": "Ramon",
      "lastName": "Valdez"
    }, datePla: {
      category: "Friends",
      number: 9,
      wins: 10,
      loses: 12,
      hRuns: 2,
      balls: 3,
      outs: 2,
      stoBase:3,
      img: "004.png"
    }	
  },
  {
    name: {
      "id": 4,
      "firstName": "Gabriel",
      "lastName": "Garcia Marquez"
    }, datePla: {
      category: "Pony",
      number: 10,
      wins: 10,
      loses: 12,
      hRuns: 2,
      balls: 3,
      outs: 2,
      stoBase:3,
      img: "005.png"
    }	
  },
  {
    name: {
      "id": 5,
      "firstName": "Juan",
      "lastName": "Pijamas"
    }, datePla: {
      category: "Yong",
      number: 10,
      wins: 10,
      loses: 12,
      hRuns: 2,
      balls: 3,
      outs: 2,
      stoBase:3
    }	
  },
  {
    name: {
      "id": 6,
      "firstName": "Mookie",
      "lastName": "Betts"
    }, datePla: {
      category: "Pony",
      number: 10,
      wins: 10,
      loses: 12,
      hRuns: 2,
      balls: 3,
      outs: 2,
      stoBase:3
    }	
  },
  {
    name: {
      "id": 7,
      "firstName": "Mookie",
      "lastName": "Betts"
    }, datePla: {
      category: "Pony",
      number: 10,
      wins: 10,
      loses: 12,
      hRuns: 2,
      balls: 3,
      outs: 2,
      stoBase:3
    }	
  },
  {
    name: {
      "id": 8,
      "firstName": "Mookie",
      "lastName": "Betts"
    }, datePla: {
      category: "Profesional",
      number: 10,
      wins: 10,
      loses: 12,
      hRuns: 2,
      balls: 3,
      outs: 2,
      stoBase:3
    }	
  }
];


function initx(){
  var list = document.getElementById('listPlayer');

  for (var i = 0; i < players.length; i++) {
    var name = document.createElement('div');

    name.setAttribute("class", "namePlayers");
    name.setAttribute("id", i);
    name.setAttribute("onClick", "datePlayer("+players[i].name.id+")");
    name.innerHTML = "<div>"+players[i].name.firstName +" "+ players[i].name.lastName+"</div>";
    list.appendChild(name);
  }

}


//llena la tabla con los datos del jugador seleccionado usando el ID
function datePlayer(id){
  var name = document.getElementById('namePlayer');
  var cate = document.getElementById('plCategory');
  var num = document.getElementById('plNum');
  var plImg = document.getElementById('plImg');
  var img = document.getElementById('userNone');

  name.innerHTML = "<b>"+players[id].name.firstName +" "+ players[id].name.lastName+"</b>";
  cate.innerHTML = " "+players[id].datePla.category;
  num.innerHTML = " "+players[id].datePla.number;
  img.src = "img/"+players[id].datePla.img;
  plImg.appendChild(img);
  divSelect(players[id].name.id);
  idAnt = players[id].name.id;

  var w = document.getElementById('wins');
  w.innerHTML = players[id].datePla.wins;
}

//pone de color los nombre seleccionados
function divSelect(idDiv){

  var div = document.getElementById(idDiv);
  var divNamPlay = document.getElementsByClassName("namePlayers");
  for (var i = 0; i < divNamPlay.length; i++) {
    if (i==idDiv) 
      div.style.backgroundColor = "#AD8FF2";
    else
      divNamPlay[i].style.backgroundColor = "";
  }
}

//////////////////////////////////
function showTable(id) {
  //get table
  var table = document.getElementById('table');
  for (var i = 1; i <= 10; i++) {
    //create row
    var row = document.createElement('tr');
    //number cell

    addCellToRow(row, i);

    //add row to table
    table.appendChild(row);
  }

}


