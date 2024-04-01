#include <app/main.hpp>
#include <app/app1.h>
#include <app/app2.hpp>
#include <dll/dll1.h>
#include <dll/dll2.hpp>
#include <lib/lib1.h>
#include <lib/lib2.hpp>
#include <iostream>

using namespace std;

int main(int argc, char *argv[], char *env[]) {
    cout << "Application started" << endl;

    app1();
    app2();

    dll1();
    dll2();

    lib1();
    lib2();

    cout << "Application finished" << endl;
    return 0x00;
}
