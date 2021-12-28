#pragma once

#include <sqlite3.h>

typedef void (*errorLogHandler)(void *arguments, int errorCode, const char *message);

static inline void registerErrorLogCallback(errorLogHandler callback) {
    sqlite3_config(SQLITE_CONFIG_LOG, callback, 0);
}
