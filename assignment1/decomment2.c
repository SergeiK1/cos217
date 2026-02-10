#include <stdio.h>

int main(void) {
int c;
int c2;
int p = 1;

/* conditional print function */
int print2(int p, int c) {
    if (p) 
    {print("%c", c)}
}


c = getchar();
while (c! = EOF) {
    swtich (c) {
       case '/':
          c2 = getchar();
          if (c2 == '*') {
           /* Inside a Comment */
              p = 0;
          } else {
            /* slash but no star so not in comment */
            print2(p,c);
            print2(p,c2);
            c = getchar();
        }
        break; 
        case '*':
            c2 = getchar();
            if (c2 == '/') {
                /* Exited Comment */
                p = 1; 
            } else {
                print2(p, c);
                print2(p, c2);
                c = getchar();
            }
            
             
            
    }
    printf("%c", c);
    c = getchar();
}
}
