#include "apint.h"

int main()
{
    printf("Default constructor test array contents\n");
    Apint default1 = defaultApint();
    print(default1);
    printf("\n");
    
    char* word1 = "+23";
    Apint strConstructor = stringConstructor(word1,2);
    printf("\n\n");
    
    int numbers[] = {1,4,0,2,3};
    intToApint(numbers,5);
    printf("\n\n");
    
    
    
    char x[] = {'2','8','0'};
    char y[] = {'0','4','2'};
    Apint c = newApint(x,3);
    Apint d = newApint(y,3);
    printf("The addition result is 280 + 42 = \n");
    addition(c,d);
    printf("\n");
    
    char x1[] = {'1','8'};
    char y1[] = {'1','2'};
    Apint e = newApint(x1,2);
    Apint f = newApint(y1,2);
    printf("The subtraction result is 18 - 12 = \n");
    subtract(e,f);
    printf("\n");
    
    char x2[] = {'1','0'};
    char y2[] = {'0','5'};
    Apint g = newApint(x2,2);
    Apint h = newApint(y2,2);
    printf("The multiplcation result is 10 * 5 = \n");
    multiplcation(g,h);
    printf("\n");
    
    char x3[] = {'8','8'};
    char y3[] = {'2','2'};
    Apint a = newApint(x3,2);
    Apint b = newApint(y3,2);
    
    printf("The division result is 88 / 22 = \n");
    int result = divide(a,b);
    printf("%i",result);
    
    return 0;
}

