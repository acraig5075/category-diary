TEMPLATE = app
TARGET = category-diary
QT += quick sql

SOURCES += \
    main.cpp \
    event.cpp \
    sqleventmodel.cpp \
    database.cpp \
    categoryquerymodel.cpp \
    sqlstatsmodel.cpp \
    stats.cpp

RESOURCES += \
    category-diary.qrc

OTHER_FILES += \
    main.qml

DISTFILES += \
    Content.qml \
    SettingsIcon.qml

target.path = $$[QT_INSTALL_EXAMPLES]/quickcontrols/extras/category-diary
INSTALLS += target

HEADERS += \
    event.h \
    sqleventmodel.h \
    database.h \
    categoryquerymodel.h \
    sqlstatsmodel.h \
    stats.h
