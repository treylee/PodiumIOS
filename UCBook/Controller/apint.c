/******************************************************************************
 
 Online C Compiler.
 Code, Compile, Run and Debug C program online.
 Write your code in this editor and press "Run" button to compile and execute it.
 
 *******************************************************************************/

#include <stdio.h>
#include <string.h>
#include "apint.h"


Apint defaultApint(){
    Apint S = (Apint)malloc(sizeof(ap));
    
    for (int i = 9; i >= 0; i--) {
        
        S->arr[i] =  '0';
        printf(" %i",S->arr[i]-'0');
        
    }
    
    return S;
    
    
}
Apint stringConstructor(char *k, int len){
    
    Apint S = (Apint)malloc(sizeof(ap));
    char * x = k;
    char operation = x[0];
    x++;
    printf("String Constuctor Test \nThe operation is  %c the string taken is %s" ,operation,x);
    k++;
    for (int i = 9; i >= 0; i--) {
        if (len > 0 ){
            S->arr[i] =  k[len];
            len--;
        } else {
            S->arr[i] =  '0';
            
        }
        
    }
    
    return S;
    
    
}
Apint intToApint(int k[], int len){
    
    Apint S = (Apint)malloc(sizeof(ap));
    printf("The int converted to  APInt Test - Array Contents \n");
    for (int i = 0; i < len; i++) {
        S->arr[i] = k[i];
        printf("%d",k[i]);
        
    }
    
    return S;
    
}
Apint newApint(char number[],int count2) {
    
    
    Apint S = (Apint)malloc(sizeof(ap));
    //S->dic[]
    S->length =2;
    //printf("the length %i",S->length);
    int count = count2-1;
    
    for (int i = 9; i >= 0; i--) {
        
        if (count  < 0){
            // printf("break\n");
            S->arr[i] =  '0';
        }else {
            //int tmp = number[count] - '0';
            //printf(" tmp %\cn\n",number[count]);
            S->arr[i] =  number[count];
            S->numItems++;
            count--;
            
        }
        //  x++;
        
    }
    for (int i = 0; i < 10; i++) {
        //printf("%i",S->arr[i]);
    }
    return S;
}
void print(Apint printArr) {
    for (int i = 0; i < 10; i++) {
       // printf("%c",printArr->arr[i]);
    }
    printf("\n");
}

void addition(Apint num1 ,Apint num2){
    int carry = 0;
    int len = num2->numItems;
    int result = 0;
    char aux[10];
    
    for (int i = 9; i >= 0; i--) {
        int tmp1 = (num1->arr[i]-'0');
        int tmp2 = (num2->arr[i]-'0');
        //  printf(" %i",tmp1);
        // printf(" %i\n",tmp2);
        
        result = (tmp1 + tmp2 + carry) % 10;
        carry = (tmp1 + tmp2 + carry) / 10;
        aux[i] = result;
        //printf(" %i carry %i \n",aux[i],carry);
        
    }
    int hitdigit = 0;
    for (int i = 0; i < 10;i++){
        int tmp = aux[i];
        // printf("aa %i", tmp);
        
        if (tmp != 0 )
            printf("%i", tmp);
    }
}

void subtract(Apint num1 ,Apint num2){
    char aux[10];
    int count = 0;
    
    for (int i = 9; i >= 0; i--) {
        int number1 = num1->arr[i] - '0';
        int number2 = num2->arr[i] - '0';
        if (count > 0){
            number1 = aux[i] - '0';
        }
        //    printf("number 1/2 %i %i \n ", number1,number2);
        
        if (number1 < number2) {
            int j = i - 1;
            int number1aux = num1->arr[j] - '0';
            //    printf(" number 1 aux %i \n",number1aux);
            while (num1->arr[j] < 1) {
                num1->arr[j] = 9;
                //    printf("now is 9");
                j--;
            }
            num1->arr[j] = num1->arr[j-1];
            num1->arr[i] = num1->arr[i+10];
            int number3 = num1->arr[j-1] - '0';
            int number4 = num2->arr[i+10] - '0';
            // printf("subtracting %i %i \n ", number3,number4);
            
            aux[i] = (number3- number4);
        } else {
            
            aux[i] = (number1 - number2);
        }
        //    count++;
    }
    int hitdigit = 0;
    for (int i = 0; i < 10;i++){
        int tmp = aux[i];
        // printf("aa %i", tmp);
        
        if (tmp != 0 )
            printf("%i", tmp);
    }
    
    
}

void multiplcation(Apint num1, Apint num2){
    int carry = 0;
    int len = num2->numItems;
    int result = 0;
    char aux[10];
    int count = 0;
    
    for( int j = 0; j<4;j++){
        for (int i = 9; i >= 0; i--) {
            int tmp1;
            int tmp2;
            if (count < 1) {
                tmp1 = (num1->arr[i]-'0');
                tmp2 = (num1->arr[i]-'0');
            }
            else {
                
                tmp1 = (aux[i]);
                tmp2 = (num1->arr[i]-'0');
            }
            //  printf(" %i",tmp1);
            // printf(" %i\n",tmp2);
            
            result = (tmp1 + tmp2 + carry) % 10;
            carry = (tmp1 + tmp2 + carry) / 10;
            aux[i] = result;
        }
        
        count++;
        for (int i = 0; i < 10;i++){
            //printf("%i", aux[i]);
        }
        //   printf("next iteration \n");
        
        
        
    }
    int hitdigit = 0;
    for (int i = 0; i < 10;i++){
        int tmp = aux[i];
        // printf("aa %i", tmp);
        
        if (tmp != 0 )
            printf("%i", tmp);
    }
    
    
    
}
int returnLarger(Apint num1,Apint num2){
    for (int i = 0;i<10;i++){
        //printf( " %i ",num1->arr[i] );
        //   printf( " %i ",num2->arr[i] );
        
    }
    //  printf( "\n" );
    
    int bigger = 1;
    if (num1->numItems > num2->numItems) {
        return 5;
    } else if (num1->numItems < num2->numItems) {
        return 0;
    }
    else {
        for (int i = 0; i < 10; i++) {
            int tmpx = num1->arr[i] - '0';
            int tmpy = num2->arr[i] - '0';
            //    printf("%i ------  %i\n",tmpx,tmpy);
            
            if (tmpx > tmpy) {
                bigger = 1;
                break;
            } else if (tmpx < tmpy) {
                bigger = 0;
                break;
            }
        }
    }
    return bigger;
}
int divide(Apint num1 , Apint num2) {
    int answer = 0;
    char aux[10];
    int count = 0;
    
    while(returnLarger(num1, num2)) {
        
        for (int i = 9; i >= 0; i--) {
            int number1 = num1->arr[i] - '0';
            int number2 = num2->arr[i] - '0';
            if (count > 0){
                number1 = aux[i] - '0';
            }
            //  printf("number 1/2 %i %i \n ", number1,number2);
            
            if (number1 < number2) {
                int j = i - 1;
                int number1aux = num1->arr[j] - '0';
                //    printf(" number 1 aux %i \n",number1aux);
                while (num1->arr[j] < 1) {
                    num1->arr[j] = 9;
                    //    printf("now is 9");
                    j--;
                }
                num1->arr[j] = num1->arr[j-1];
                num1->arr[i] = num1->arr[i+10];
                int number3 = num1->arr[j-1] - '0';
                int number4 = num2->arr[i+10] - '0';
                // printf("subtracting %i %i \n ", number3,number4);
                
                aux[i] = (number3- number4) + '0';
            } else {
                
                aux[i] = (number1 - number2) + '0';
            }
            
        }
        
        for (int i = 0;i<10;i++){
            num1->arr[i] = aux[i];
            //  printf( " %i",num1->arr[i] );
        }
        // printf( "\n" );
        answer++;
        
        
    }
    
    
    return answer;
}
