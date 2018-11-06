#ifndef _apint_H_INCLUDE_
#define _apint_H_INCLUDE_


struct apintObj{
    int numItems;
    char arr[10];
    int length;
};

typedef struct apintObj ap;
typedef ap *Apint;


Apint newApint(char number[],int count2);
void print(Apint printArr);
void addition(Apint num1 ,Apint num2);
void subtract(Apint num1 ,Apint num2);
void multiplcation(Apint num1, Apint num2);
int returnLarger(Apint num1,Apint num2);
int divide(Apint num1 , Apint num2);
#endif
