########################################################################
#            F I R S T    P A S S     T R A N S L A T I O N            #
########################################################################

    .text
# Testing how first-pass translations work


main:

init:
    li          %numA, 5
    li          %numB, 6

addition:
    add         $s0, %numA, %numB
print:
    move        $a0, $s0
    li          $v0, 1
    syscall
end:
    jr          $ra

