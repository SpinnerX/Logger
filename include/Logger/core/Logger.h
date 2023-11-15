#pragma once
#include <cstring>
#include <memory>
#include <formatCpp/formatCpp.h>
#include <formatCpp/datetime.h>
#include <formatCpp/ffstream.h>
#include "../utility/colors.h"

namespace Logger{
    template<typename... T>
    inline void warn(std::string fmt, T&&... args){
        auto current = std::chrono::system_clock::now();
        formatCpp::print(formatCpp::format("{}{:%c} [WARN] >> {}{}", Colors::Yellow, current, fmt, Colors::Reset), (args)...);
    }

    template<typename... T>
    inline void info(std::string fmt, T&&... args){
        auto current = std::chrono::system_clock::now();
        formatCpp::print(formatCpp::format("{}{:%c} [INFO] >> {}{}", Colors::Green, current, fmt, Colors::Reset), (args)...);
    }

    template<typename... T>
    inline void debug(std::string fmt, T&&... args){
        auto current = std::chrono::system_clock::now();
        formatCpp::print(formatCpp::format("{}{:%c} [DEBUG] >> {}{}", Colors::Blue, current, fmt, Colors::Reset), (args)...);
    }

    template<typename... T>
    inline void trace(std::string fmt, T&&... args){
        auto current = std::chrono::system_clock::now();
        formatCpp::print(formatCpp::format("{}{:%c} [TRACE] >> {}{}", Colors::Blue, current, fmt, Colors::Reset), (args)...);
    }

    template<typename... T>
    inline void error(std::string fmt, T&&... args){
        auto current = std::chrono::system_clock::now();
        formatCpp::print(formatCpp::format("{}{:%c} [ERROR] >> {}{}", Colors::Red, current, fmt, Colors::Reset), (args)...);
    }

    template<typename... T>
    inline void fatal(std::string fmt, T&&... args){
        auto current = std::chrono::system_clock::now();
        formatCpp::print(formatCpp::format("{}{:%c} [FATAL] >> {}{}", Colors::Red, current, fmt, Colors::Reset), (args)...);
    }



    // For right now this is how we are going to log files.
    // Logging to a file
    // Specifying the file to send logs too.
    // Sooner or later, we may want to create an API for basically say if we have multiple files that we created and want to write/read to
    // Then we have a queue or hash table basically saying files["out.txt"].write("Something")
    // or create a function to do that, where we do write("out.txt", "messages");
    // But we need there to be a statement like: Logger::open("out.txt"); which will open this file
    // for reading/writing

    // NOTE: Might be a better way to doing this, but for now gonna leave it like this
    // This is just to get something working and then rethinking how this may work.
    class LoggingToFile : public formatCpp::v9::ostream {
    public:
        friend class formatCpp::v9::ostream;
        LoggingToFile() = delete; // Do not implicltly create a default constructor
        template<typename... T>
        LoggingToFile(std::string filename, T&&... params) : ostream(filename, formatCpp::detail::ostream_params(params...)){
            // LoggingToFile(std::string filename, T... params) : formatCpp::save(filename, params...){
        }

    public:
        template<typename... T>
        static inline void create(std::string filename, T&&... args){
            instance = new LoggingToFile(filename, args...);
        }

        template<typename... T>
        inline void warn(std::string fmt, T&&... args){
            if(instance == nullptr){
                error("Instantiate the create() when writing to file!\n");
                return;
            }

            auto current = std::chrono::system_clock::now();
            // formatCpp::print(formatCpp::format("{}WARN[{:%c}]:{} {}", Colors::Yellow, current, Colors::Reset, fmt, (args)...));
            // instance->print(formatCpp::format("{:%c} -- WARN -- {}", current, fmt, (args)...));
            this->print(formatCpp::format("{:%c} [WARN] >> {}", current, fmt, (args)...));

        }

        template<typename... T>
        inline void info(std::string fmt, T&&... args){
            if(instance == nullptr){
                error("Instantiate the create() when writing to file!\n");
                return;
            }
            auto current = std::chrono::system_clock::now();
            this->print(formatCpp::format("{:%c} [INFO] >> {}", current, fmt), (args)...);
        }

        template<typename... T>
        inline void debug(std::string fmt, T&&... args){
            if(instance == nullptr){
                error("Instantiate the create() when writing to file!\n");
                return;
            }

            auto current = std::chrono::system_clock::now();
            this->print(formatCpp::format("{:%c} [DEBUG] >> {}", current, fmt, (args)...));
        }

        template<typename... T>
        inline void trace(std::string fmt, T&&... args){
            if(instance == nullptr){
                error("Instantiate the create() when writing to file!\n");
                return;
            }

            auto current = std::chrono::system_clock::now();
            this->print(formatCpp::format("{:%c} [TRACE] >> {}", current, fmt), (args)...);
        }

        template<typename... T>
        inline void error(std::string fmt, T&&... args){
            if(instance == nullptr){
                error("Instantiate the create() when writing to file!\n");
                return;
            }

            auto current = std::chrono::system_clock::now();
            this->print(formatCpp::format("{:%c} [ERROR] >> {}", current, fmt), (args)...);
        }

        template<typename... T>
        inline void fatal(std::string fmt, T&&... args){
            if(instance == nullptr){
                error("Instantiate the create() when writing to file!\n");
                return;
            }

            auto current = std::chrono::system_clock::now();
            
            this->print(formatCpp::format("{:%c} [FATAL] >> {}", current, fmt), (args)...);
        }

        static LoggingToFile* getInstance() { return instance; }

    private:
        static LoggingToFile* instance; // We want to create one instance for logging to specific files.
    };

    // This class may be redundant for righht now, but just want some things to work for rn
    // Having this log, send logs to specific types of user - whether its application clients, from engine, etc.
    class Log{
    public:
        Log() = delete; // Do not implicltly create a default constructor
        Log(std::string logTo) : name(logTo) {}

        template<typename... T>
        inline void warn(std::string fmt, T&&... args){
            auto current = std::chrono::system_clock::now();
            formatCpp::print(formatCpp::format("{}{:%c} [{} - WARN] >> {}{}", Colors::Yellow, current, name, fmt, Colors::Reset), (args)...);
        }

        template<typename... T>
        inline void info(std::string fmt, T&&... args){
            auto current = std::chrono::system_clock::now();
            formatCpp::print(formatCpp::format("{}{:%c} [{} - INFO] >> {}{}", Colors::Green, current, name, fmt, Colors::Reset), (args)...);
        }

        template<typename... T>
        inline void debug(std::string fmt, T&&... args){
            auto current = std::chrono::system_clock::now();
            formatCpp::print(formatCpp::format("{}{:%c} [{} - DEBUG] >> {}{}", Colors::Blue, current, name, fmt, Colors::Reset), (args)...);
        }

        template<typename... T>
        inline void trace(std::string fmt, T&&... args){
            auto current = std::chrono::system_clock::now();
            formatCpp::print(formatCpp::format("{}{:%c} [{} - TRACE] >> {}{}", Colors::Blue, current, name, fmt, Colors::Reset), (args)...);
        }

        template<typename... T>
        inline void error(std::string fmt, T&&... args){
            auto current = std::chrono::system_clock::now();
            formatCpp::print(formatCpp::format("{}{:%c} [{} - ERROR] >> {}{}", Colors::Red, current, name, fmt, Colors::Reset), (args)...);
        }

        template<typename... T>
        inline void fatal(std::string fmt, T&&... args){
            auto current = std::chrono::system_clock::now();
            formatCpp::print(formatCpp::format("{}{:%c} [{} - FATAL] >> {}{}", Colors::Red, current, name, fmt, Colors::Reset), (args)...);
        }
    private:
        std::string name; // specifying name of what we are sending the logs to
    };

    Log* SendLogs(std::string sendLogTo){
        return new Log(sendLogTo);
    }

    template<typename... T>
    inline void saveLog(std::string filename, T&&... args){
        LoggingToFile::create(filename, args...);
    }

    template<typename... T>
    LoggingToFile open(std::string fmt, T... args){
        return LoggingToFile(fmt, args...);
    }

    template<typename... T>
    inline void warnToFile(std::string fmt, T&&... args){
        // return LoggingToFile(fmt).warn((args)...);
        LoggingToFile::getInstance()->warn(fmt, args...);
    }

    template<typename... T>
    inline void infoToFile(std::string fmt, T&&... args){
        return LoggingToFile(fmt).info((args)...);
    }

    template<typename... T>
    inline void debugToFile(std::string filename, std::string fmt, T&&... args){
        return LoggingToFile(filename).debug(fmt, (args)...);
    }

    template<typename... T>
    inline void traceToFile(std::string fmt, T&&... args){
        return LoggingToFile(fmt).trace((args)...);
    }

    template<typename... T>
    inline void errorToFile(std::string fmt, T&&... args){
        return LoggingToFile(fmt).error((args)...);
    }

    template<typename... T>
    inline void fatalToFile(std::string fmt, T&&... args){
        return LoggingToFile(fmt).fatal((args)...);
    }

    LoggingToFile* LoggingToFile::instance = nullptr;
};