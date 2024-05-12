.macro set_hires() {
  lda BASE_VIC + 17
  ora #32
  sta BASE_VIC + 17

  // lda 53272
  // ora #8
  // sta 53272

}

.macro disable_basic() {
  // $01 Desactivamos la rom del basic, no la vamos a necesitar
  /*
    $36 = 00110110

    0 NOT USED
    0 NOT USED
    1 Cassette Motor Switch Control. A 1 turns the motor on, 0 turns it off.
    1 Cassette Switch Sense. Reads 0 if a button is pressed, 1 if not.

    0 Cassette Data Output line.
    1 CHAREN signal. Selects character ROM or I/O devices. 1=I/O, 0=ROM
    1 HIRAM signal. Selects ROM or RAM at 57344 ($E000). 1=Kernal, 0=RAM
    0 LORAM signal. Selects ROM or RAM at 40960 ($A000). 1=BASIC, 0=RAM
  */

  lda $01
  and #%11111100
  ora #$02 
  sta $01 
}



.macro select_bank_for_vic() {
  /* 
      Bits #0-#1: VIC bank. Values:
      %00, 0: Bank #3, $C000-$FFFF, 49152-65535.
      %01, 1: Bank #2, $8000-$BFFF, 32768-49151. 
      %10, 2: Bank #1, $4000-$7FFF, 16384-32767. (este)
      %11, 3: Bank #0, $0000-$3FFF, 0-16383.
  */
    
    // BANK 1
    lda $dd00
    and #%11111100
    ora #%10
    sta $dd00  

    lda VIC_MCR
    and #%11100001
    ora #%00001000 // CHAR MEM $2000
    ora #%00010000 // SCREEN MEM $0400
    sta VIC_MCR
}