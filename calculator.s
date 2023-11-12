#
# Usage: ./calculator <op> <arg1> <arg2>
#

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

# int main(int argc, char argv[][])
main:
  # Function prologue
  enter $0, $0

  # Variable mappings:
  # op -> %r12
  # arg1 -> %r13
  # arg2 -> %r14
  movq 8(%rsi), %r12  # op = argv[1]
  movq 16(%rsi), %r13 # arg1 = argv[2]
  movq 24(%rsi), %r14 # arg2 = argv[3]


  # Hint: Convert 1st operand to long int
  movq %r13, %rdi
  call atol
  movq %rax, %r13
  movq $format, %rdi
  mov $0, %al
  # Hint: Convert 2nd operand to long int

  movq %r14, %rdi
  call atol
  movq %rax, %r14
  movq $format, %rdi
  mov $0, %al

  # Hint: Copy the first char of op into an 8-bit register
  # i.e., op_char = op[0] - something like mov 0(%r12), ???

  mov 0(%r12), %cl

#determines if (op_char == '+') 
  mov $'+', %bl

  cmp %bl, %cl

  je add

#determines if op == '-' 

  mov $'-', %bl

  cmp %bl, %cl

  je subtract


#determines if op == '*'
  mov $'*', %bl

  cmp %bl, %cl

  je multiply

#determines if op == '/'
  mov $'/', %bl

  cmp %bl, %cl

  je non0


# error handeling, if op is assigned an incorrect value, print the error letting 
# the user know 
  mov $messageOP, %rdi
  mov $0,%al
  call printf
  jmp end

  # Function epilogue

#adds the first and second arguements, arg1 + arg2 
   add:
     addq %r13, %r14
     movq %r14, %rsi
     jmp output

#subtracts the first arg by the 2nd arg, arg1 - arg2
   subtract:
     subq %r14, %r13
     movq %r13, %rsi
     jmp output

#multiples the 1st arg by the 2nd arg, arg1 * arg2
 multiply:
     imulq %r14, %r13
     movq %r13, %rsi
     jmp output

#determines if the 2nd arguement is a 0, if so, print error, if not divide
non0:
  cmp $0, %r14
  jne divide
  je error

#prints an error saying you can not divide by 0
error:
 mov $message0, %rdi
 call printf
 jmp end

#divide the first arg by the 2nd arg, arg1 / arg2
divide:
  movq %r13, %rax
  movq %r14, %rbx
  cqto
  idivq %rbx
  movq %rax, %rsi
  jmp output


#generaic print statement for any output in this program
   output:
     mov $0, %al
     mov $format, %rdi
     call printf
     jmp end

#ends the program
   end:


  leave
  ret


# Start of the data section
.data

format:
  .asciz "%ld\n"

messageOP:
    .asciz "Please enter a valid opperation (+, -, *, /) \n"

message0:
    .asciz "You can not divide by 0 \n"
    jmp end
