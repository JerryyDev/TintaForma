checa_chao();
ativa_debug();
pega_inputs();
movimento();
ajusta_escala();


retorna_efeito_mola();


//Rodando o meu estado
estado();

if(keyboard_check_pressed(ord("R"))){
    room_restart();
}