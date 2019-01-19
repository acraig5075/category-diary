TEMPLATE = app
TARGET = category-diary
QT += quick sql

SOURCES += \
    main.cpp \
    database.cpp \
    categoryquerymodel.cpp \
    stats.cpp \
    eventsquerymodel.cpp

RESOURCES += \
    category-diary.qrc

OTHER_FILES += \
    main.qml

DISTFILES += \
    Content.qml \
    SettingsIcon.qml \
    Categories.qml \
    Diary.qml \
    Summary.qml

target.path = $$[QT_INSTALL_EXAMPLES]/quickcontrols/extras/category-diary
INSTALLS += target

HEADERS += \
    database.h \
    categoryquerymodel.h \
    stats.h \
    eventsquerymodel.h
