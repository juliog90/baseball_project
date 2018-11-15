function init(){
    console.log('Initialazing...');
    var menu = document.getElementById('menuButton');
    var leftmenu = document.getElementById('leftmenu');
    menu.onclick = function() {leftmenu.style.display = 'block';}
}