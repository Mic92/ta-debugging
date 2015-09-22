.global _start
.text
_start:
    mov $1, %rax   # use the write syscall
    mov $1, %rdi   # write to stdout
    mov $msg, %rsi # use string "Hello World"
    mov $12, %rdx  # write 12 characters
    syscall        # make syscall

    mov $60, %rax  # use the _exit syscall
    mov $0, %rdi   # error code 0
    syscall        # make syscall

.data
msg: .ascii "Hello World\n"
