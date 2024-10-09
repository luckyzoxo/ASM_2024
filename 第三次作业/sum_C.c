#include<stdio.h>

int main() {
	int result = 0;
	for (int i = 1; i <= 100; i++)
		result += i;
	printf("%d", result);
	return 0;
}