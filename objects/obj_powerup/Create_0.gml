alvo = noone;

indo_para_o_player = function(){
    if(!alvo) return;
        
    x = alvo.x;
    y = alvo.y - 37;
}

explosao = function(){
    repeat (20) {
        var part = instance_create_layer(x, y, "Efeitos", obj_part_powerup);
        var _direction = random(359);
        part.speed = random_range(4, 5);
        part.direction = _direction;
        
        part.alvo = alvo;
    }
}