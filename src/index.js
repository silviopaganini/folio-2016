import Demo from './demo';

const demo = new Demo();
window.onresize = demo.onResize.bind(demo);

function playVideo(e)
{
  let video = e.target.querySelector('video');
  if(!video) return;
  video.play();
}

function stopVideo(e)
{
  let video = e.target.querySelector('video');
  if(!video) return;
  video.pause();
}

let buttons = document.querySelectorAll('.container-project');
for (var i = 0; i < buttons.length; i++) {
  buttons[i].addEventListener('mouseover', playVideo);
  buttons[i].addEventListener('mouseleave', stopVideo);
}

let subButtons = document.querySelectorAll('.container-project > .submenu > button');
for(var i = 0; i<subButtons.length; i++)
{
  subButtons[i].addEventListener('click', function(e){
    e.preventDefault();
    window.open(e.target.dataset.href)
  });
}

let submenus = document.querySelectorAll('.container-project > .submenu');
console.log(submenus);
for(var i = 0; i<submenus.length; i++)
{
  let a = submenus[i]
  a.parentNode.addEventListener('click', function(e){
    var display = a.currentStyle ? a.currentStyle.display : getComputedStyle(a, null).display;

    if(display != 'none') {
      e.preventDefault();
    }
    
  }.bind(this));
}
