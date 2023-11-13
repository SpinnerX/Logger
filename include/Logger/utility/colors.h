#pragma once
#include <cstring>
#include <string>
#include <cstdlib>


namespace Logger{
    namespace Colors{
        // # Reset
        const std::string Reset="\033[0m";          // Text Reset

        // Regular Colors
        const std::string Black="\033[0;30m";        // Black
        const std::string Red="\033[0;31m";          // Red
        const std::string Green="\033[0;32m";        // Green
        const std::string Yellow="\033[0;33m";       // Yellow
        const std::string Blue="\033[0;34m";         // Blue
        const std::string Purple="\033[0;35m";       // Purple
        const std::string Cyan="\033[0;36m";         // Cyan
        const std::string White="\033[0;37m";        // White

        // Bold
        const std::string BBlack="\033[1;30m";       // Black
        const std::string BRed="\033[1;31m";         // Red
        const std::string BGreen="\033[1;32m";       // Green
        const std::string BYellow="\033[1;33m";      // Yellow
        const std::string BBlue="\033[1;34m";        // Blue
        const std::string BPurple="\033[1;35m";      // Purple
        const std::string BCyan="\033[1;36m";        // Cyan
        const std::string BWhite="\033[1;37m";       // White

        // Underline
        const std::string UBlack="\033[4;30m";       // Black
        const std::string URed="\033[4;31m";         // Red
        const std::string UGreen="\033[4;32m";       // Green
        const std::string UYellow="\033[4;33m";      // Yellow
        const std::string UBlue="\033[4;34m";        // Blue
        const std::string UPurple="\033[4;35m";      // Purple
        const std::string UCyan="\033[4;36m";        // Cyan
        const std::string UWhite="\033[4;37m";       // White

        // Background
        const std::string On_Black="\033[40m";       // Black
        const std::string On_Red="\033[41m";         // Red
        const std::string On_Green="\033[42m";       // Green
        const std::string On_Yellow="\033[43m";      // Yellow
        const std::string On_Blue="\033[44m";        // Blue
        const std::string On_Purple="\033[45m";      // Purple
        const std::string On_Cyan="\033[46m";        // Cyan
        const std::string On_White="\033[47m";       // White

        // High Intensity
        const std::string IBlack="\033[0;90m";       // Black
        const std::string IRed="\033[0;91m";         // Red
        const std::string IGreen="\033[0;92m";       // Green
        const std::string IYellow="\033[0;93m";      // Yellow
        const std::string IBlue="\033[0;94m";        // Blue
        const std::string IPurple="\033[0;95m";      // Purple
        const std::string ICyan="\033[0;96m";        // Cyan
        const std::string IWhite="\033[0;97m";       // White

        // Bold High Intensity
        const std::string BIBlack="\033[1;90m";      // Black
        const std::string BIRed="\033[1;91m";        // Red
        const std::string BIGreen="\033[1;92m";      // Green
        const std::string BIYellow="\033[1;93m";     // Yellow
        const std::string BIBlue="\033[1;94m";       // Blue
        const std::string BIPurple="\033[1;95m";     // Purple
        const std::string BICyan="\033[1;96m";       // Cyan
        const std::string BIWhite="\033[1;97m";      // White

        // High Intensity backgrounds
        const std::string On_IBlack="\033[0;100m";   // Black
        const std::string On_IRed="\033[0;101m";     // Red
        const std::string On_IGreen="\033[0;102m";   // Green
        const std::string On_IYellow="\033[0;103m";  // Yellow
        const std::string On_IBlue="\033[0;104m";    // Blue
        const std::string On_IPurple="\033[0;105m";  // Purple
        const std::string On_ICyan="\033[0;106m";    // Cyan
        const std::string On_IWhite="\033[0;107m";   // White
    };
};