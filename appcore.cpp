#include "appcore.h"

AppCore::AppCore(QObject *parent) : QObject(parent) {

}

void AppCore::openFile(QString path) {
    QFile file(path);
    file.open(QIODevice::ReadOnly);
    if (!file.exists()) emit fileOpened(""); else emit fileOpened(file.readAll());
}

void AppCore::saveFile(QString path, QString text) {
    QFile file(path);
    file.open(QIODevice::WriteOnly);
    if (!file.write(text.toUtf8())) emit fileSaved(0); else emit fileSaved(1);
}
