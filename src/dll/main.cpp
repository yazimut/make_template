#include <iostream>

using namespace std;

void __attribute__((constructor)) __init__() {
    cout << "DLL has been initialized" << endl;
}

void __attribute__((destructor)) __fini__() {
    cout << "DLL has been finilized" << endl;
}
