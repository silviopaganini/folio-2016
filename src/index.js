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

let buttons = document.querySelectorAll('a.container-project');
for (var i = 0; i < buttons.length; i++) {
  buttons[i].addEventListener('mouseover', playVideo);
  buttons[i].addEventListener('mouseleave', stopVideo);
}
