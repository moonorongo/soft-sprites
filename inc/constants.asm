#importonce 

.const SCREEN_INTERRUPT_LINE = 51

.const BASE_VIC = $d000
.const VIC_MCR = BASE_VIC + $18

.const BASE_VIC_BANK = $4000 

.const BASE_VIC_VIDEO_SCREEN_CHARS = BASE_VIC_BANK + $400
.const BASE_VIC_HIRES_MEMORY = BASE_VIC_BANK + $2000

.const JOYSTICK_2= $DC00

/* 
tmp_address:
  .byte $00,$00

// resultado de la fn
CALC_BYTE_OUTPUT: 
  .byte $00,$00


*/