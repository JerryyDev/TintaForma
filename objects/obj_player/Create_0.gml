
inicia_efeito_mola();

#region Iniciando as variaveis

velh            = 0; //velocidade horizontal
max_velh        = 1; //Velocidade maxima horizontal
velv            = 0; //Velocidade vertical
max_velv        = 4.8; //Velocidade maxima vertical
grav            = 0.3; //Gravidade

//Variaveis de inputs
right       = false;
left        = false;
jump        = false;
down        = false;
tinta       = false;
debug       = false;

//Variaveis do level
chao                   = false;
chao_tinta             = false;
teto                   = false;
estou_na_tinta         = false;
global.peguei_powerup  = false;


//Variavel de lista de colisoes
//Pegando a minha layer
var _layer = layer_tilemap_get_id("tl_level");
colisores = [obj_block, _layer];


view_player = noone;

dir = 1;


//Variaveis dos estados
estado = noone;

#endregion


teto = place_meeting(x, y - 1, colisores);


#region Métodos

checa_chao = function()
{
    chao = place_meeting(x, y + 1, colisores);
    
    var tile_tinta = layer_tilemap_get_id("tl_tinta");
    chao_tinta = place_meeting(x, y+1, tile_tinta);
}

//Método para pegar inputs
pega_inputs = function()
{
    right        = keyboard_check(ord("D"));
    left         = keyboard_check(ord("A"));
    jump         = keyboard_check_pressed(vk_space);
    down         = keyboard_check(ord("S"));
    tinta        = keyboard_check_pressed(vk_shift);
    debug        = keyboard_check_pressed(vk_tab);
}

//Método de movimentação
aplica_velocidade = function()
{
    checa_chao();
    
    //Fazendo ele se mover
    //Dando velocidade pro player
    velh = (right - left) * max_velh;
    
    //Aplicando a gravidade
    //Se eu estou no chão eu aplico a gravidade á minha velv
    //Caso contrario eu zero meu velv
    if(!chao)
    {
        velv = velv + grav;
    }
    else
    {
        velv = 0;
        
        y = round(y)
        
        if(jump)
        {
            velv = -max_velv;
            
            //Se eu não estou na tinta eu posso criar a particula
            if(estou_na_tinta == false){
                instance_create_depth(x, y, depth - 1, obj_particula_pulo);   
            }
        }
    }
    
    //Limitando a velocidade vertical
    velv = clamp(velv, -max_velv, max_velv);    
}


roda_debug = function()
{
    show_debug_overlay(!global.debug);
    
    view_player = dbg_view("view_player", 1, 40, 10, 300, 400);
    
    //Vendo as informações da minha velv
    dbg_watch(ref_create(self, "velv"), "velv")
    
    dbg_slider(ref_create(self, "max_velv"), 3, 10, "Max velv", .1);
    
    dbg_slider(ref_create(id, "grav"), 0.1, 0.5, "Gravidade",  0.1);
}

ativa_debug = function()
{
    if(!DEBUG_MODE) return;
        
    if(debug)
    {
        global.debug = !global.debug;
        
        if(global.debug)
        {
            roda_debug();
        }
        else 
        {
            show_debug_overlay(global.debug);
            
            if(dbg_view_exists(view_player))
            {
                dbg_view_delete(view_player);
            }
        }
    }
}


ajusta_escala = function(){
    if(velh < 0){
        dir = -1;
    }
    else if(velh > 0){
        dir = +1;
    }
}


movimento = function()
{
    //move_and_collide na horizontal
    move_and_collide(velh, 0, colisores, 4);
    
    //move_and_collide na vertical
    move_and_collide(0, velv, colisores, 34);
    
    if(place_meeting(x, y-1, colisores)){
        grav += 0.05
    }
    else{
        grav = 0.3;
    }
}

#endregion





#region estados

troca_sprite = function(sprite)
{
    if(sprite == undefined)
    {
        sprite = spr_player_idle;    
    }
    
    if(sprite_index != sprite)
    {
        sprite_index = sprite;
        //Zero a animação da sprite
        image_index = 0;
    }
}


troca_animation = function(animation_end, next_animation)
{
    if(animation_end == undefined)
    {
        animation_end = false;    
    }
    
    if(next_animation == undefined)
    {
        next_animation = noone;
    }
    
    if(animation_end == true)
    {
       estado = next_animation;
    }
}

acabou_animation = function(posso_troca, prox_animation, destruction)
{
    if(posso_troca == undefined)
    {
        posso_troca = false;
    }
    
    if(prox_animation == undefined){
        prox_animation = noone;
    }
    
    var spd = sprite_get_speed(sprite_index) / FPS
    if(image_index + spd > image_number - 1){
        troca_animation(posso_troca, prox_animation);
    }
}

//Método de parado
estado_parado = function()
{
    aplica_velocidade();
    
    //Definindo a sprite
    troca_sprite();
    
    //Falando que não estou na tinta
    estou_na_tinta = false;
    
    //Mudando a sprite se eu apertei para ir para direita ou para a esquerda
    if(right xor left)
    {
        estado = estado_movendo;
    }
    
    //Indo para o estado de pulo se eu apertei espaço
    if(jump)
    {
        estado = estado_pulo;
        
        efeito_mola(.1, 1.2);
    }
    
    if(!chao)
    {
        estado = estado_pulo;
    }
    
    //Se eu não estou na tina
    if(estou_na_tinta == false){
        //E eu apertei para entrar na tinta
        if(tinta && global.peguei_powerup == true && chao_tinta){
            //Eu mudo de estado
            estado = estado_entra_tinta;
            
            //Criando a particula
            instance_create_depth(x, y + 1, depth - 1, obj_particula_tinta_entra);  
        }
    }
}


estado_movendo = function()
{
    aplica_velocidade();
    //Definindo a sprite
    troca_sprite(spr_player_walk);
    
    //Indo para o estado de pulo se eu apertei espaço
    if(velv != 0)
    {
        estado = estado_pulo;
    }
    
    //Se eu não estou me movendo eu mudo a minha sprite
    if(velh == 0)
    {
        estado = estado_parado;
    }
    
    if(place_meeting(x, y, obj_powerup)){
        global.peguei_powerup = true;
        estado = estado_powerup_inicio;
    }
}



estado_pulo = function()
{
    aplica_velocidade();
    //Definindo a sprite
    //pulei eu mudo a sprite
    if(velv < 0)
    {
        troca_sprite(spr_player_jump_up);
        if(array_contains(colisores, obj_block_one_way)){
            var ind = array_get_index(colisores, obj_block_one_way);
            array_delete(colisores, ind, 1);
        }
        colisores[2] = obj_block;
    }
    else if (velv > 0){ //estou caindo eu mudo a sprite
        troca_sprite(spr_player_jump_down);
        if(!place_meeting(x, y, obj_block_one_way))
        {
            if(!array_contains(colisores, obj_block_one_way)){
                array_push(colisores, obj_block_one_way);
            }
            //colisores[2] = obj_block_one_way;
        }
    }
    
    //Indo para o estado de parado se eu estou no chão
    if(chao)
    {
        estado = estado_parado;
        
        instance_create_depth(x, y, depth - 1, obj_particula_pouso);
            
        efeito_mola(1.2, .4);
    }
}      
        



estado_powerup_inicio = function()
{
    velh = 0;
    velv = 0;
    //Definindo a sprite
    troca_sprite(spr_player_powerup_inicio);
    
    var spd = sprite_get_speed(sprite_index) / FPS
    //Indo para o estado parado se essa acabou
    acabou_animation(true, estado_powerup_meio);
}


estado_powerup_meio = function()
{
    //Definindo a sprite
    troca_sprite(spr_player_powerup_mid);
    if(!instance_exists(obj_part_powerup))
        estado = estado_powerup_fim;
}


estado_powerup_fim = function()
{
    //Definindo a sprite
    troca_sprite(spr_player_powerup_end);
    
    acabou_animation(true, estado_parado);
    
    instance_destroy(obj_powerup);
}


estado_entra_tinta = function(){
    //Definindo a sprite
    troca_sprite(spr_player_entra_tinta);
    
    //Definindo o estado que eu vou se a animação acabou
    acabou_animation(true, estado_na_tinta);
    
    //Zerando o meu velh
    velh = 0;
}

//Estado de loop da tinta
estado_na_tinta = function(){
    //Definindo a sprite
    troca_sprite(spr_player_in_tinta);
    //Fazendo com que eu consiga me mover
    aplica_velocidade();
    
    //Zerando o velv
    velv = 0
    var tile_tinta = layer_tilemap_get_id("tl_level");
    var parar = !place_meeting(x + (velh * 18), y + 1, colisores);
    //Se não tem parede na minha esquerda ou na minha direita
    if(parar){
        //Eu zero meu velh
        velh = 0;
    }
    
    //Falando que estou na tinta
    estou_na_tinta  = true;
    
    //Se eu estou na tinta
    if(estou_na_tinta == true){
        //E eu apertei o botão de pular
        if(tinta){
            //Eu mudo de estado
            estado = estado_sai_tinta;
            
            //Criando a particula
            instance_create_depth(x, y + 1, depth - 1, obj_particula_sai_tinta);
        }
    }
}


estado_sai_tinta = function(){
    //Definindo a sprite
    troca_sprite(spr_player_sai_tinta);
    
    //Definindo o estado que eu vou
    acabou_animation(true, estado_parado);
    
    //Zerando o meu velh
    velh = 0;
}

#endregion

//Estado inicial
estado = estado_parado;