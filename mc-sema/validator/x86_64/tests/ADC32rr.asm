BITS 64
;TEST_FILE_META_BEGIN
;TEST_TYPE=TEST_F
;TEST_IGNOREFLAGS=
;TEST_FILE_META_END
    ; Adc32RR
    mov eax, 0x1234abcd
    mov edx, 0x2345bcde
    ;TEST_BEGIN_RECORDING
    adc eax, edx
    ;TEST_END_RECORDING

