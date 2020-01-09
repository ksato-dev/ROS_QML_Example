#include "ros/ros.h"
#include "std_msgs/String.h"

#include <string>
#include <functional>
#include <iostream>

#include <QCoreApplication>
#include <QTimer>
#include <QObject>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>
#include <QString>
#include <QQuickWindow>
#include <QtQml>
#include <QtConcurrent/QtConcurrent>
#include <QFuture>
#include <QFutureWatcher>
#include <QString>

#include "qml_mediator.h"
#include "error_message.h"

using namespace std;

int main(int argc, char** argv)
{
    //Init ros stuff
    ros::init(argc, argv, "talker");
    ros::NodeHandle node;
    ros::Publisher pub = node.advertise<std_msgs::String>("chatter", 1000);
    
    //Init Qt
    QGuiApplication app(argc, argv);
    QMLMediator mediate(&app);
    QMLErrorMessage err_msg(&app);

    //Start ros in separate thread, and trigger Qt shutdown when it exits
    //If Qt exits before ros, be sure to shutdown ros
    QFutureWatcher<void> rosThread;
    rosThread.setFuture(QtConcurrent::run(&ros::spin));
    QObject::connect(&rosThread, &QFutureWatcher<void>::finished, &app, &QCoreApplication::quit);
    QObject::connect(&app, &QCoreApplication::aboutToQuit, [](){ros::shutdown();});

    //5 second timer to publish
    QTimer sec5;
    QTimer sec1;
    sec5.setInterval(5000);
    sec1.setInterval(1000);

    //Set up slot for 5 second timer
    int i=0;    
    QObject::connect(&sec5, &QTimer::timeout, [&]()
    {
        std_msgs::String msg;
        
        msg.data = string("Message #" + to_string(i++)).c_str();
        mediate.addString("Sending [" + QString(msg.data.c_str()) + "]");

        pub.publish(msg);
    });

    bool display_flag = true;
    QObject::connect(&sec1, &QTimer::timeout, [&]()
    {
        std_msgs::String msg;

        if (display_flag)
            msg.data = string("FATAL_ERROR").c_str();
        else
            msg.data = string("").c_str();

        err_msg.updateString(QString(msg.data.c_str()));

        display_flag = !display_flag;
    });
   
    QQmlApplicationEngine engine(&app);
    engine.rootContext()->setContextProperty("mediator", &mediate);
    engine.rootContext()->setContextProperty("error_message", &err_msg);
    engine.load(QUrl("qrc:///qml/line_display.qml"));    

    //Start timer
    sec5.start();
    sec1.start();

    //Start main app
    return app.exec();
}
