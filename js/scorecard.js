function init(){
  console.log('Initialazing...');
  let menu = document.getElementById('menuButton');
  let leftmenu = document.getElementById('leftmenu');
  menu.onclick = function() {leftmenu.style.display = 'block';}
}
