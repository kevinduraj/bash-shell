#include <iostream>
#include "hello.h"
#include "name.h"

using namespace std;


int main()
{
    cout << "program start " << endl;

    Hello hello;
    hello.kevin();

    Name name;
    name.mynameis();
   
    return 0;
}
