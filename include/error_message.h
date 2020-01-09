#ifndef ERROR_MESSGAE_H
#define ERROR_MESSGAE_H

#include "ros/ros.h"
#include "std_msgs/String.h"

#include <QObject>
#include <QString>
#include <QDebug>

class QMLErrorMessage : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString str READ getString NOTIFY stringChanged);
    QString m_str;

public:
    QMLErrorMessage(QObject* parent = nullptr)
    {
        connect(this, &QMLErrorMessage::newString, this, &QMLErrorMessage::newStringSlot);
    }

    QString getString()
    {
        return this->m_str;
    }

    void updateString(const QString& s)
    {
        this->m_str = s;
        newString(s);
    }

    //Emit this as a signal to be caught locally in order to prevent race conditions
    void updateString(const std_msgs::String::ConstPtr& msg)
    {  
        this->m_str = QString(msg->data.c_str());
        newString(msg->data.c_str());
    }

signals:
    void stringChanged();
    void newString(QString s);

private slots:
    void newStringSlot(QString s)
    {
        this->m_str = s;
        stringChanged();
    }
};

#endif
