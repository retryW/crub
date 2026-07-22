; Tell compiler to compile for 16-bit mode coz REALMODE
BITS 16
; change the offset to where bootloader should be loaded by BIOS
org 0x7c00

; Get the CPU to loop so we know it's working
; This is a 2-byte directive
jmp $

; Boot segments are 512 bytes in size
; Pad the rest of the bytes with 0s, leaving 2 bytes at the end
times 510 - ($ - $$) db 0

; Write the special "bootloader" identifier to the final 2 bytes
dw 0x55AA
