//Me desenhando 
//draw_self();

//Desenhando o brilho
//Efeito de brilho
var esc = random_range(0, 0.02)
gpu_set_blendmode(bm_add);
draw_sprite_ext(spr_brilho_tocha, 0, x, y, 0.35 + esc, 0.35 + esc, 0, c_white, 0.13);
gpu_set_blendmode(bm_normal);   