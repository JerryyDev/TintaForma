

#macro DEBUG_MODE 0
#macro FPS game_get_speed(gamespeed_fps)

#macro normal_mode:DEBUG_MODE 0
#macro debug_mode:DEBUG_MODE 1


global.debug = false;


//Função de efeito
function inicia_efeito_mola(){
    //Variaveis
    xscale = 1;
    yscale = 1;
}

function efeito_mola(_xscale = 1, _yscale = 1){
    xscale = _xscale;
    yscale = _yscale;
}

function retorna_efeito_mola(spd){
    if(spd == undefined){
        spd = .1;
    }
    
    xscale = lerp(xscale, 1, spd);
    yscale = lerp(yscale, 1, spd);
}


function desenha_efeito_mola(){
    draw_sprite_ext(sprite_index, image_index, x, y, xscale * dir, yscale, image_angle, image_blend, 1);
}

