var spd = sprite_get_speed(sprite_index) / FPS
if(image_index + spd > image_number){
    instance_destroy();
}