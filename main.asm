// BUILD AND RUN = F6
#import "inc/pointers.asm"
#import "inc/constants.asm" 

BasicUpstart2(main)

main:
  sei
  disable_interrupts()  
  set_hires() 
  disable_basic()
  enable_vic_irq()
  select_bank_for_vic()

  // clear MSB raster
  lda $d011
  and #%01111000
  ora #%00000101 // fix vertical position
  sta $d011

  // Set interrupt line
  lda #SCREEN_INTERRUPT_LINE
  sta $d012 

  lda #<intcode
  sta 788      
  lda #>intcode
  sta 789
  
  cli

  // Background colors
  lda #BLACK
  sta BASE_VIC + $20
  lda #BLACK
  sta BASE_VIC + $21

  // clear screen
  jsr clear_screen

  ldx #0
  stx sprite_x  // posicion X del sprite

main_loop:
  ldx loop_flag
  beq loop_flag_false
  jmp do_all_checks // loop_flag true 

loop_flag_false:
  jmp exit

// todo este codigo se ejecuta SYNC con el refresco de pantalla
do_all_checks:
  ldx #0 
  stx loop_flag

  lda #WHITE
  sta BASE_VIC + $20

.for (var i = 0; i < 7; i++) {
  ldx #i * $10
  stx sprite_y  // posicion Y del sprite

  // puntero del sprite que quiero copiar
  ldx #<crazy_face
  stx SPR_PUT_SPRITE_POINTER
  ldx #>crazy_face
  stx SPR_PUT_SPRITE_POINTER + 1

  jsr calc_bytes  // calcula posicion memoria para pintar sprite
  jsr put_sprite  // pinta el sprite
}




  inc sprite_x

  lda #BLACK
  sta BASE_VIC + $20


exit:
  jmp main_loop
// END PROGRAM




// Interrupt code for SCREEN_INTERRUPT_LINE
intcode:
  ldx #1 
  stx loop_flag
  // stx $d020 // test length in cycles

out_interrupt:
  // SALIDA DEL GAME LOOP
  inc $d019           // acusamos recibo

  pla             
  tay             
  pla             
  tax             
  pla             
  rti



loop_flag:
.byte $ff

#import "inc/subroutines/put_sprite.asm"
#import "inc/subroutines/calc_byte.asm"
#import "inc/subroutines/clear_screen.asm"

#import "inc/macros/config.asm"

#import "inc/tables.asm"

* = $c000 "Crazy Face"
#import "inc/sprites/crazy_face.asm"
