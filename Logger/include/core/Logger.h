#pragma once
#include <cstring>
#include <formatCpp/formatCpp.h>
#include <formatCpp/datetime.h>
#include <common/colors.h>
#include <common/Message.h>

namespace Logger{
    template<typename... T>
    void warn(std::string fmt, T&&... args){
        auto current = std::chrono::system_clock::now();
        formatCpp::print(formatCpp::format("{}WARN[{:%c}]:{} {}", Colors::Yellow, current, Colors::Reset, fmt, (args)...));
    }

    template<typename... T>
    void info(std::string fmt, T&&... args){
        auto current = std::chrono::system_clock::now();
        formatCpp::print(formatCpp::format("{}INFO[{:%c}]:{} {}", Colors::Yellow, current, Colors::Reset, fmt), (args)...);
    }

    template<typename... T>
    void debug(std::string fmt, T&&... args){
        auto current = std::chrono::system_clock::now();
        formatCpp::print(formatCpp::format("{}DEBUG[{:%c}]:{} {}", Colors::Blue, current, Colors::Reset, fmt), (args)...);
    }

    template<typename... T>
    void trace(std::string fmt, T&&... args){
        auto current = std::chrono::system_clock::now();
        formatCpp::print(formatCpp::format("{}TRACE[{:%c}]:{} {}", Colors::Blue, current, Colors::Reset, fmt), (args)...);
    }

    template<typename... T>
    void error(std::string fmt, T&&... args){
        auto current = std::chrono::system_clock::now();
        formatCpp::print(formatCpp::format("{}ERROR[{:%c}]:{} {}", Colors::Red, current, Colors::Reset, fmt), (args)...);
    }

    template<typename... T>
    void fatal(std::string fmt, T&&... args){
        auto current = std::chrono::system_clock::now();
        formatCpp::print(formatCpp::format("{}FATAL[{:%c}]:{} {}", Colors::Red, current, Colors::Reset, fmt), (args)...);
    }
};