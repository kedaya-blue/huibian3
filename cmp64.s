/* store 
 * x0 src1
 * x1 step1
 * x2 src2
 * x3 step2
 * x4 dst
 * x5 step3
 * x6 width
 * x7 height
 */
    .global lt
lt:
    sub     sp, sp, #40
    str     x8, [sp]
    str     x9, [sp, #8]
    str     x10, [sp, #16]
    str     x11, [sp, #24]
    str     x12, [sp, #32]

    sub     x1, x1, x7, lsl #4
    sub     x3, x3, x7, lsl #4
    sub     x5, x5, x7, lsl #4

start_loop:
    sub     x6, x6, #1
    cmp     x6, #0
    beq     end_loop

    sub     x8, x7, #16    /* x8 <- width - width_step */
    add     x8, x4, x4

start_loop1:
    cmp     x4, x7
    bgt     end_loop1

    ldr     q0, [x2]
    ldr     q1, [x0]
    cmgt    v0.4s, v1.4s, v0.4s

    umov    w9, v0.4s[0]
    cmp     w9, #0x00
    movne   w9, #0xFF
    moveq   w9, #0
    mov     w10, w9

    umov    w9, v0.4s[1]
    cmp     w9, #0x00
    movne   w9, #0xFF
    moveq   w9, #0
    orr     w10, w9, lsl #8

    umov    w9, v0.4s[2]
    cmp     w9, #0x00
    movne   w9, #0xFF
    moveq   w9, #0
    orr     w10, w9, lsl #16

    umov    w9, v0.4s[3]
    cmp     w9, #0x00
    movne   w9, #0xFF
    moveq   w9, #0
    orr     w10, w9, lsl #24

    str     w10, [x4]

    add     x0, x0, #16
    add     x2, x2, #16
    add     x4, x4, #4
    b       start_loop1

end_loop1:
    add     x7, x7, #16

start_loop2:
    cmp     x4, x7
    bge     end_loop2

    ldr     x9, [x0]
    ldr     x10, [x2]
    cmp     x9, x10
    movne   x9, #255
    moveq   x9, #0
    strb    x9, [x4]

    add     x0, x0, #4
    add     x2, x2, #4
    add     x4, x4, #1

end_loop2:

    add     x0, x0, x1, lsl #2 /* src1 += step1 */
    add     x2, x2, x3, lsl #2 /* src2 += step2 */
    add     x4, x4, x5, lsl #2 /* dst += step3 */
    b       start_loop

end_loop:
    ldr     x8, [sp]
    ldr     x9, [sp, #8]
    ldr     x10, [sp, #16]
    ldr     x11, [sp, #24]
    ldr     x12, [sp, #32]
    add     sp, sp, #8
    bx      lr
