#include <stdio.h>
#include <math.h>

int main() {
    int n = 10;    
    printf("Enter 10 numbers:\n");
    double data[10];
    for (int i = 0; i < n; i++) {
        printf("Input number: ");
	scanf("%lf", &data[i]);
    }

    double total = 0;
    for (int i = 0; i < n; i++) {
	    data[i] = sqrt(data[i]);
	    total += data[i];
    }
    total /= n;
    printf("The average of the square roots of the numbers is: %f\n", total);
}
