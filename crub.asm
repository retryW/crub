; Tell compiler to compile for 16-bit mode coz REALMODE
BITS 16
; change the offset to where bootloader should be loaded by BIOS
org 0x7c00

; Add our string pointer to a register
; No you cannot directly increment a label pointer in a register
; need to assign it to a register first and increment the register instead
mov bx, banner

printbanner:
    ; Using interrupt table from https://en.wikipedia.org/wiki/BIOS_interrupt_call#:~:text=Interrupt%21table
    ; Set function number for Write Character in TTY Mode
    mov ah, 0x0e
    ; Set output character to the current index in our string
    mov al, [bx]
    ; Increment string pointer index
    inc bx
    ; Check if we reached the end of the string
    cmp al, 0
    je loop
    ; Send "Video Services" interrupt to BIOS
    INT 0x10
    ; Do it again if we haven't reached the end of the string
    jne printbanner

; Get the CPU to loop so we know it's working
; This is a 2-byte directive
loop:
    jmp $

; Data needs to be at the bottom as it gets baked into the executable
; as uninitialized data causing CPU to lose it's mind...
; No I didn't waste an hour figuring out why my code wouldn't work
; But not before the padding you moron... Definitely not another hour...
banner:
    db "===CRUB===", 0

; Boot segments are 512 bytes in size
; Pad the rest of the bytes with 0s, leaving 2 bytes at the end
times 510 - ($ - $$) db 0

; Write the special "bootloader" identifier to the final 2 bytes
; dw 0x55AA - This doesn't work because of little endian...
;            In memory it gets stored as 0xAA, 0x55 because 0xAA is the LSB
;            I could make it dw 0xAA55 but that's confusing.
db 0x55, 0xAA

