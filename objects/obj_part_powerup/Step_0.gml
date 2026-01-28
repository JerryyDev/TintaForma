if(!alvo) exit;
    
image_xscale = lerp(image_xscale, speed * 1, 0.1);
image_angle = direction;

if(voltar == false){
    speed -= 0.1;
    if(speed <= 0){
        voltar = true;
        
        var xx = alvo.x + random_range(-5, 5);
        var yy = alvo.y - 12 + random_range(-7, 7);
        var dir = point_direction(x, y, xx, yy);
        direction = dir;
    }
}
else {
    speed += 0.1;
    
    var x_mola, y_mola;
    x_mola = choose(1.2, 0.90);
    y_mola = choose(0.8, 0.78);
    
    var col_player = instance_place(x, y, obj_player);
    if(col_player){
        with(col_player){
            efeito_mola(x_mola, y_mola);
        }
        
        instance_destroy();
    }
}

