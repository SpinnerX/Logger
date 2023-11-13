// #include <Logger/core/Logger.h>
#include <Logger/core/Logger.h>
#include <optional>
#include <iostream>
#include <string>

// Mocking up Box type
struct Box {
    int value = 0;
};

template<typename T>
struct MyTypes{
    T val = T();
    std::optional<T> val2 = std::nullopt;
    MyTypes() = default;
    MyTypes(T const& v) : val(v) {}
};

struct TestInt{
    int val;
    TestInt() = default;
    TestInt(int const& v) : val(v) {}
};

MyTypes<Box> createBox(){
    Box b;
    b.value = 2;
    return b;
}

TestInt create(){
    int x = 0;
    return x;
}

int main(){
    Logger::info("Just for your information!\n");
    MyTypes<Box> b = createBox();
    Logger::info("Information Value - {}\n", b.val.value);
}