// BUILD AND RUN = F6
#import "inc/pointers.asm"
#import "inc/constants.asm" 

BasicUpstart2(main)

main:
  set_hires() 
  disable_basic()
  select_bank_for_vic()

  
  // Background colors
  lda #BLACK
  sta BASE_VIC + $20
  lda #BLACK
  sta BASE_VIC + $21

  // clear screen
  jsr clear_screen



  // TEST CALC BYTES
  ldx #200
  stx sprite_x  // posicion X del sprite

  ldx #150
  stx sprite_y  // posicion Y del sprite

  // puntero del sprite que quiero copiar
  ldx #<crazy_face
  stx SPR_PUT_SPRITE_POINTER
  ldx #>crazy_face
  stx SPR_PUT_SPRITE_POINTER + 1

  jsr calc_bytes  // calcula posicion memoria para pintar sprite
  jsr put_sprite  // pinta el sprite



main_loop:
  inc $d020
exit:
  jmp main_loop

#import "inc/subroutines/put_sprite.asm"
#import "inc/subroutines/calc_byte.asm"
#import "inc/subroutines/clear_screen.asm"

#import "inc/macros/config.asm"

#import "inc/tables.asm"

* = $c000 "Crazy Face"
#import "inc/sprites/crazy_face.asm"
