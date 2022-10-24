#include <QObject>
#include <QFile>

#ifndef APPCORE_H
#define APPCORE_H


class AppCore : public QObject {
    Q_OBJECT
public:
    explicit AppCore(QObject *parent = nullptr);

public slots:
    void openFile(QString path);
    void saveFile(QString path, QString text);

signals:
    void fileOpened(QString text);
    void fileSaved(int status);
};

#endif // APPCORE_H
