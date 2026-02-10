#include <stdio.h>

int main(void) {

    int c, c2;

    int line = 1;
    int comment_start_line = 1;
    int in_comment = 0;
    int saw_star = 0;
    int in_string = 0;
    int in_char = 0;
    int escape = 0;
    
    int have_c = 0; 

    while (1) {
        
        if (!have_c) c = getchar();
        else have_c = 0;  /* to process / reprocess one a time */ 

        if (c == EOF) break; /*needed to cathc all instances and not print the endline char*/

        if (c == '\n') line++; /* track line numbers */

        /* Inside comment logic */

        if (in_comment) {
            if (c == '\n') putchar('\n'); /* still want to track new lines even in comments*/

            /* Exiting Comment */
            if (saw_star && c == '/') {
                in_comment = 0;
                saw_star = 0;
            } else {
                saw_star = (c == '*'); /* tracks the exit of comment within comment */
            }

            continue; /* loops back to top until exit of a comment */
        }

        /* Tracking for being inside a string */

        if (in_string) {
            putchar(c);
            if (escape) escape = 0; /* Reset escape character */
            else if (c == '\\') escape = 1; /* In escape character */
            else if (c == '"') in_string = 0; /* Exit String */

            continue; /* loop back */

        }

        /* Tracking for being in char literals */
        /* Basically same as above */
        if (in_char) {
            putchar(c);
            
            if (escape) escape = 0;
            else if (c == '\\') escape = 1;
            else if (c == '\'') in_char = 0;
            
            continue;
        }

        /* Normal now outside of all special scenarios */
        /* Basically tracking the entry into all these special modes */
        
        if (c == '"') {
            in_string = 1;
            escape = 0;
            putchar(c);
            continue; 
        }

        if (c == '\'') {
            in_char = 1;
            escape = 0;
            putchar(c);
            continue;
        }

        if (c == '/') {
            c2 = getchar();
            if (c2 == EOF) { /* File ends after slash */
                putchar('/');
                break;
            }
            if (c2 == '\n') line++; /*since we already read c2 we need to make sure to act on it */
            
            if (c2 == '*') {
                /* We have no entered a comment */
                putchar(' ');
                in_comment = 1;
                saw_star = 0;
                comment_start_line = line;
                continue;
            }

            /* if it was not a comment then make sure to print all that you tracked */
            putchar('/');
            c = c2;
            have_c = 1;
            continue;
        }
        if (c != EOF) {
            putchar(c);
        }
    }

    /* if the file ends and your still in a comment then throw error */

    if (in_comment) {
        fprintf(stderr, "Error: line %d: unterminated comment\n", comment_start_line);
        return 1; /* Failure */
    }

    return 0; /* Success */
}
