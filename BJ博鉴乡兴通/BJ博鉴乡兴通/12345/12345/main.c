//
//  main.c
//  12345
//
//  Created by nanxun on 2025/4/1.
//

#include <stdio.h>
#include <string.h>
int isprime(int a) {
    int c = 2;
    while (a % c != 0) {
        c++;
    }
    if (c == a) {
        return 1;
    } else {
        return 0;
    }
}
int isHui(int a) {
    int num[6];
    int last = 0;
    while (a > 0) {
        num[last++] = a % 10;
        a = a / 10;
    }
    int c = 0;
    while (c < last) {
        if (num[c++] != num[--last]) {
            return 0;
        }
    }
    return 1;
}
int change(int a) {
    int count;
    int countOne = 0;
    int countZero = 0;
    while (a > 0) {
        count = a % 2;
        if (count == 0) {
            countZero++;
        } else {
            countOne++;
        }
        a = a / 2;
    }
    if (countOne > countZero) {
        return 1;
    } else {
        return 0;
    }
    
}
int main() {
    int a = 0;
    int b = 0;
    int op;
    scanf("%d %d", &a, &b);
    int num[1200] = {0};
    for (int i = 0; i <= b; i++) {
        scanf("%d", &op);
        if (op == 1) {
            num[0] = !num[0];
            num[a - 1] = !num[a - 1];
            num[1] = !num[1];
        } else if (op == a) {
            num[a - 2] = !num[a - 2];
            num[a - 1] = !num[a - 1];
            num[0] = !num[0];
        } else {
            num[op - 2] = !num[op - 2];
            num[op] = !num[op];
            num[op - 1] = !num[op - 1];
        }
    }
    for (int i = 0; i < a; i++) {
        printf("%d ", num[i]);
    }
    return 0;//过程结束
}
