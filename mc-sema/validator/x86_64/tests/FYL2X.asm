BITS 64
;TEST_FILE_META_BEGIN
;TEST_TYPE=TEST_F
;TEST_IGNOREFLAGS=FLAG_FPU_PE
;TEST_FILE_META_END

lea rdi, [rsp-0xc]
mov word [rdi], 0x10
FILD word [rdi]
FILD word [rdi]

;TEST_BEGIN_RECORDING
FYL2X ;st1 = 16 * log2(16)
;TEST_END_RECORDING

