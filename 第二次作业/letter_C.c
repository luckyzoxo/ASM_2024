#include <stdio.h>

int main() {
	for (char ch = 'a'; ch <= 'z'; ch++) {
		printf("%c", ch);
		if (ch - 'a' == 13)
			printf("\n");
	}
	return 0;
}