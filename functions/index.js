const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(); //this function will initialize firestore trigger with our app

exports.myFunction = functions.firestore
.document('chat/{message}')
.onCreate((snapshot , context) => {
    return admin.messaging().sendToTopic('chat',{ //this returns that push notification when we get a message
        notification : {
            title: snapshot.data().username,
            body: snapshot.data().text,
            clickAction : 'FLUTTER_NOTIFICATION_CLICK',
        }
    });
});

