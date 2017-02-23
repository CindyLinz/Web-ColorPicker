var brd = document.querySelector('#brd');
var color_area = document.querySelector('#color_area');
var color_bar = document.querySelector('#color_bar');
var init_width = 256;
var init_height = 256;
var padding = 5;
color_bar.width = 20;
color_bar.height = init_height;
color_area.width = init_width;
color_area.height = init_height;
brd.style.width = init_width + 20 + 'px';
brd.style.height = init_height + 'px';
brd.style.padding = padding + 'px';

var area_choose = { x: .5, y: .5 };
var bar_choose = .5;
var real_rgb;

var rgb2hex = function(rgb){
  var out = '#';
  var i, x;
  for(i=0; i<3; ++i){
    x = rgb[i] * 255; if( x<0 ) x=0; if( x>255 ) x=255; x = parseInt(x, 10);
    if( x<16 ) out += '0'; out += x.toString(16);
  }
  return out;
};

var rgb2rgb = function(r, g, b){
  return [r,g,b];
}

var hsv2rgb = function(h, s, v){
  var c = v * s;
  var m = v - c;
  var hh = h*6;
  var x = c * (1 - Math.abs(hh % 2 - 1));
  var r, g, b;
  if( hh < 1 )
    r=c, g=x, b=0;
  else if( hh < 2 )
    r=x, g=c, b=0;
  else if( hh < 3 )
    r=0, g=c, b=x;
  else if( hh < 4 )
    r=0, g=x, b=c;
  else if( hh < 5 )
    r=x, g=0, b=c;
  else
    r=c, g=0, b=x;
  r += m;
  g += m;
  b += m;
  return [r,g,b];
};

var hsl2rgb = function(h, s, l){
  var c = (1 - Math.abs(2*l-1)) * s;
  var m = l - c/2;
  var hh = h*6;
  var x = c * (1 - Math.abs(hh % 2 - 1));
  var r, g, b;
  if( hh < 1 )
    r=c, g=x, b=0;
  else if( hh < 2 )
    r=x, g=c, b=0;
  else if( hh < 3 )
    r=0, g=c, b=x;
  else if( hh < 4 )
    r=0, g=x, b=c;
  else if( hh < 5 )
    r=x, g=0, b=c;
  else
    r=c, g=0, b=x;
  r += m;
  g += m;
  b += m;
  return [r,g,b];
};

var real2hsv = function(rgb){
  var M = 0;
  var m = 1;
  var i;
  for(i=0; i<3; ++i){
    if( rgb[i] < m ) m = rgb[i];
    if( rgb[i] > M ) M = rgb[i];
  }
  var c = M - m;
  var h, hh;
  if( c == 0 )
    hh = 0;
  else if( M == rgb[0] )
    hh = (rgb[1]-rgb[2]) / c % 6;
  else if( M == rgb[1] )
    hh = (rgb[2]-rgb[0]) / c + 2;
  else
    hh = (rgb[0]-rgb[1]) / c + 4;
  h = hh / 6;
  var v = M;
  var s;
  if( v == 0 )
    s = 0;
  else
    s = c / v;
  return [h, s, v];
};

var real2hsl = function(rgb){
  var M = 0;
  var m = 1;
  var i;
  for(i=0; i<3; ++i){
    if( rgb[i] < m ) m = rgb[i];
    if( rgb[i] > M ) M = rgb[i];
  }
  var c = M - m;
  var h, hh;
  if( c == 0 )
    hh = 0;
  else if( M == rgb[0] )
    hh = (rgb[1]-rgb[2]) / c % 6;
  else if( M == rgb[1] )
    hh = (rgb[2]-rgb[0]) / c + 2;
  else
    hh = (rgb[0]-rgb[1]) / c + 4;
  h = hh / 6;
  var l = (M + m) / 2;
  var s;
  if( l == 1 || l == 0 )
    s = 0;
  else
    s = c / (1 - Math.abs(2*l-1));
  return [h, s, l];
};

var draw_brd = function(){
  requestAnimationFrame(function(){
    var height = brd.clientHeight - padding*2;
    var width = brd.clientWidth - 20 - padding*2;
    color_bar.width = color_bar.width;
    color_area.width = color_area.width;
    var bar_ctx = color_bar.getContext('2d');
    var area_ctx = color_area.getContext('2d');
    var out_hex = document.querySelector('#out_hex');
    var x, y;
    var sel = document.querySelector('input[name=bar_sel]:checked').value.match(/(\w+)-(\w)/);
    switch(sel[1]){
      case 'RGB': conv = rgb2rgb; break;
      case 'HSV': conv = hsv2rgb; break;
      case 'HSL': conv = hsl2rgb; break;
    }
    switch(sel[0]){
      case 'RGB-R': case 'HSV-H': case 'HSL-H':
        for(y=0; y<height; ++y){
          bar_ctx.fillStyle = rgb2hex(conv(y/(height-1), area_choose.x, area_choose.y));
          bar_ctx.fillRect(0, y, 20, 1);

          for(x=0; x<width; ++x){
            area_ctx.fillStyle = rgb2hex(conv(bar_choose, x/(width-1), y/(height-1)));
            area_ctx.fillRect(x, y, 1, 1);
          }
        }
        real_rgb = conv(bar_choose, area_choose.x, area_choose.y)
        break;
      case 'RGB-G': case 'HSV-S': case 'HSL-S':
        for(y=0; y<height; ++y){
          bar_ctx.fillStyle = rgb2hex(conv(area_choose.y, y/(height-1), area_choose.x));
          bar_ctx.fillRect(0, y, 20, 1);

          for(x=0; x<width; ++x){
            area_ctx.fillStyle = rgb2hex(conv(y/(height-1), bar_choose, x/(width-1)));
            area_ctx.fillRect(x, y, 1, 1);
          }
        }
        real_rgb = conv(area_choose.y, bar_choose, area_choose.x);
        break;
      case 'RGB-B': case 'HSV-V': case 'HSL-L':
        for(y=0; y<height; ++y){
          bar_ctx.fillStyle = rgb2hex(conv(area_choose.x, area_choose.y, y/(height-1)));
          bar_ctx.fillRect(0, y, 20, 1);

          for(x=0; x<width; ++x){
            area_ctx.fillStyle = rgb2hex(conv(x/(width-1), y/(height-1), bar_choose));
            area_ctx.fillRect(x, y, 1, 1);
          }
        }
        real_rgb = conv(area_choose.x, area_choose.y, bar_choose);
        break;
    }
    out_hex.value = rgb2hex(real_rgb);
    out_hex.style.border = '1px solid #ccc';

    y = bar_choose*(height-1);
    bar_ctx.fillStyle = '#000';
    bar_ctx.fillRect(0, y-1, 7, 1);
    bar_ctx.fillRect(13, y, 7, 1);
    bar_ctx.fillStyle = '#fff';
    bar_ctx.fillRect(0, y, 7, 1);
    bar_ctx.fillRect(13, y-1, 7, 1);

    x = area_choose.x*(width-1);
    y = area_choose.y*(height-1);
    area_ctx.fillStyle = '#000';
    area_ctx.fillRect(x-10, y-1, 7, 1);
    area_ctx.fillRect(x+3, y, 7, 1);
    area_ctx.fillRect(x, y-10, 1, 7);
    area_ctx.fillRect(x-1, y+3, 1, 7);
    area_ctx.fillStyle = '#fff';
    area_ctx.fillRect(x-10, y, 7, 1);
    area_ctx.fillRect(x+3, y-1, 7, 1);
    area_ctx.fillRect(x-1, y-10, 1, 7);
    area_ctx.fillRect(x, y+3, 1, 7);

    document.querySelector('#out_color').style.backgroundColor = out_hex.value;

    var rgb = real_rgb;
    document.querySelector('#RGB-R').value = rgb[0] * 100;
    document.querySelector('#RGB-G').value = rgb[1] * 100;
    document.querySelector('#RGB-B').value = rgb[2] * 100;

    var hsv = real2hsv(real_rgb);
    document.querySelector('#HSV-H').value = hsv[0] * 100;
    document.querySelector('#HSV-S').value = hsv[1] * 100;
    document.querySelector('#HSV-V').value = hsv[2] * 100;

    var hsl = real2hsl(real_rgb);
    document.querySelector('#HSL-H').value = hsl[0] * 100;
    document.querySelector('#HSL-S').value = hsl[1] * 100;
    document.querySelector('#HSL-L').value = hsl[2] * 100;
  });
};

color_area.addEventListener('mousedown', function(ev){
  ev.preventDefault();
  ev.stopPropagation();
  var upd = function(ev){
    var x = ev.clientX - color_area.offsetLeft;
    var y = ev.clientY - color_area.offsetTop;
    if( x < 0 ) x = 0;
    if( x >= color_area.width ) x = color_area.width-1;
    if( y < 0 ) y = 0;
    if( y >= color_area.height ) y = color_area.height-1;
    area_choose.x = x / (color_area.width-1);
    area_choose.y = y / (color_area.height-1);
    draw_brd();
  };
  upd(ev);

  var mov = function(ev){
    upd(ev);
    ev.preventDefault();
    ev.stopPropagation();
  };

  var up = function(ev){
    upd(ev);
    document.body.removeEventListener('mousemove', mov);
    document.body.removeEventListener('mouseup', up);
  };

  document.body.addEventListener('mouseup', up);
  document.body.addEventListener('mousemove', mov);
});

color_bar.addEventListener('mousedown', function(ev){
  ev.preventDefault();
  ev.stopPropagation();
  var upd = function(ev){
    var y = ev.clientY - color_bar.offsetTop;
    if( y < 0 ) y = 0;
    if( y >= color_bar.height ) y = color_bar.height-1;
    bar_choose = y / (color_bar.height-1);
    draw_brd();
  };
  upd(ev);

  var mov = function(ev){
    upd(ev);
    ev.preventDefault();
    ev.stopPropagation();
  };

  var up = function(ev){
    upd(ev);
    document.body.removeEventListener('mousemove', mov);
    document.body.removeEventListener('mouseup', up);
  };

  document.body.addEventListener('mouseup', up);
  document.body.addEventListener('mousemove', mov);
});

document.querySelector('#bar_sel').addEventListener('change', function(ev){
  var x_sel, y_sel, b_sel, tag;
  if( ev.target.getAttribute('name') === 'bar_sel' )
    tag = ev.target.value;
  else{
    tag = ev.target.id;
    document.querySelector('input[name=bar_sel][value=' + tag + ']').click();
  }
  switch( tag ){
    case 'RGB-R': b_sel = '#RGB-R'; x_sel = '#RGB-G'; y_sel = '#RGB-B'; break;
    case 'RGB-G': b_sel = '#RGB-G'; x_sel = '#RGB-B'; y_sel = '#RGB-R'; break;
    case 'RGB-B': b_sel = '#RGB-B'; x_sel = '#RGB-R'; y_sel = '#RGB-G'; break;
    case 'HSV-H': b_sel = '#HSV-H'; x_sel = '#HSV-S'; y_sel = '#HSV-V'; break;
    case 'HSV-S': b_sel = '#HSV-S'; x_sel = '#HSV-V'; y_sel = '#HSV-H'; break;
    case 'HSV-V': b_sel = '#HSV-V'; x_sel = '#HSV-H'; y_sel = '#HSV-S'; break;
    case 'HSL-H': b_sel = '#HSL-H'; x_sel = '#HSL-S'; y_sel = '#HSL-L'; break;
    case 'HSL-S': b_sel = '#HSL-S'; x_sel = '#HSL-L'; y_sel = '#HSL-H'; break;
    case 'HSL-L': b_sel = '#HSL-L'; x_sel = '#HSL-H'; y_sel = '#HSL-S'; break;
  }
  bar_choose = parseFloat(document.querySelector(b_sel).value) / 100;
  area_choose.x = parseFloat(document.querySelector(x_sel).value) / 100;
  area_choose.y = parseFloat(document.querySelector(y_sel).value) / 100;
  if( bar_choose < 0 ) bar_choose = 0; if( bar_choose > 1 ) bar_choose = 1;
  if( area_choose.x < 0 ) area_choose.x = 0; if( area_choose.x > 1 ) area_choose.x = 1;
  if( area_choose.y < 0 ) area_choose.y = 0; if( area_choose.y > 1 ) area_choose.y = 1;
  draw_brd();
});

document.querySelector('#out_hex').addEventListener('change', function(ev){
  var out_hex = ev.target;
  var match, i;
  if( match = out_hex.value.match(/^#?([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})$/) ){
  }
  else if( match = out_hex.value.match(/^#?([0-9a-fA-F])([0-9a-fA-F])([0-9a-fA-F])$/) ){
    for(i=1; i<=3; ++i)
      match[i] += match[i];
  }
  else{
    out_hex.style.border = '1px solid red';
    return;
  }
  for(i=1; i<=3; ++i)
    match[i] = parseInt(match[i], 16) / 255;
  bar_choose = match[2];
  area_choose.x = match[3];
  area_choose.y = match[1];
  document.querySelector('#RGB-R').value = match[1] * 100;
  document.querySelector('#RGB-G').value = match[2] * 100;
  document.querySelector('#RGB-B').value = match[3] * 100;
  document.querySelector('input[name=bar_sel][value=RGB-G]').click();
  draw_brd();
});

draw_brd();
