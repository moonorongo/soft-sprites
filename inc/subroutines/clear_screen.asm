clear_screen:
  ldx #$0
  lda #$10
{
l1:
  sta BASE_VIC_VIDEO_SCREEN_CHARS, x
  sta BASE_VIC_VIDEO_SCREEN_CHARS + $100, x
  sta BASE_VIC_VIDEO_SCREEN_CHARS + $200, x
  dex
  bne l1
  
// last line
l2: 
  sta BASE_VIC_VIDEO_SCREEN_CHARS + $300, x
  inx
  cpx #$e8
  bne l2

// hires cls
  ldx #0
  ldy #31
  // fill pattern 
  lda #0
l3:
  sta l3_addr_ptr:BASE_VIC_HIRES_MEMORY, x
  dex
  bne l3
  inc l3_addr_ptr + 1
  dey
  bne l3

// last 64 bytes
  ldx #64
l4:
  sta BASE_VIC_HIRES_MEMORY + $1eff, x
  dex
  bne l4

  rts
}